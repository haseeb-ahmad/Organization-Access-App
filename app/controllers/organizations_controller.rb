class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: %i[index leave]
  after_action :verify_policy_scoped, only: :index

  before_action :set_and_authorize_organization, only: %i[show edit update destroy analytics switch]

  # GET /organizations
  def index
    scope = policy_scope(Organization)
    if current_organization
      redirect_to organization_path(current_organization) and return
    else
      session[:current_organization_id] = nil
    end
    @organizations = scope
  end

  # GET /organizations/:id
  def show
    # @organization is already set and authorized
  end

  # GET /organizations/:id/edit
  def edit
    # @organization is already set and authorized
  end

  # PATCH/PUT /organizations/:id
  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/:id
  def destroy
    @organization.destroy
    redirect_to organizations_path, notice: "Organization deleted."
  end

  # PUT /organization_switcher (or /organizations/:id/switch if using member route)
  def switch
    if @organization
      session[:current_organization_id] = @organization.id
      redirect_to organization_path(@organization) and return
    else
      redirect_to organizations_path, alert: "Access denied: You are not a member of that organization."
    end
  end

  # GET /organizations/leave
  def leave
    session[:current_organization_id] = nil
    redirect_to organizations_path, notice: "You have left the current organization."
  end

  def analytics
    @total_users = @organization.users.count
    @spaces_count = @organization.spaces.count
    @posts_count = Post.joins(:space).where(spaces: { organization_id: @organization.id }).count
    @rule_sets_count = @organization.rule_sets.count

    @spaces_with_rules = @organization.spaces.joins(:rule_sets).count

    @language_distribution = @organization.users
      .group("custom_attributes ->> 'language'")
      .count
  end

  private

  def set_and_authorize_organization
    @organization = policy_scope(Organization).find(params[:id])
    authorize @organization
  end

  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
