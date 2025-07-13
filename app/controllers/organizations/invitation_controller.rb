# app/controllers/organizations/invitations_controller.rb
class Organizations::InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization

  def new
    authorize @organization, :manage_members?
    @user = User.new
  end

  def create
    authorize @organization, :manage_members?
    @user = User.invite!(invite_params) do |u|
      u.skip_invitation = false
    end

    if @user.persisted?
      Membership.create!(user: @user, organization: @organization, role: :member)
      redirect_to organization_memberships_path(@organization), notice: "Invitation sent successfully!"
    else
      render :new, alert: "Failed to invite user."
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def invite_params
    params.require(:user).permit(:email)
  end
end
