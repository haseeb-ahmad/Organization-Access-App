# app/controllers/memberships_controller.rb
class MembershipsController < ApplicationController
  def index
    authorize current_organization, :manage_members?
    @memberships = current_organization.memberships.includes(:user)
    @new_membership = Membership.new
  end

  def create
    authorize current_organization, :manage_members?

    email = params[:membership][:email].downcase.strip
    role = params[:membership][:role]

    user = User.find_by(email:)

    if user.present?
      if current_organization.users.include?(user)
        redirect_to organization_memberships_path(current_organization), alert: "User is already a member." and return
      end
    else
      user = User.invite!(email:) do |u|
        u.skip_invitation = false
      end
    end

    current_organization.memberships.create!(user:, role:)
    redirect_to organization_memberships_path(current_organization), notice: "User has been #{user.invitation_sent_at? ? 'invited' : 'added'} successfully."
  end

  def destroy
    membership = current_organization.memberships.find(params[:id])
    authorize membership
    membership.destroy
    redirect_to organization_memberships_path(current_organization), notice: "User removed from organization."
  end
end
