class SpacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_space, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[index new]
  after_action :verify_policy_scoped, only: %i[index]

  # GET /spaces
  def index
    @spaces = policy_scope(current_organization.spaces.includes(:rule_sets))
  end

  # GET /spaces/1
  def show
    authorize @space
  end

  # GET /spaces/new
  def new
    @space = current_organization.spaces.new
  end

  # GET /spaces/1/edit
  def edit
    authorize @space
  end

  # POST /spaces
  def create
    @space = current_organization.spaces.new(space_params)
    authorize @space

    respond_to do |format|
      if @space.save
        format.html { redirect_to [current_organization, @space], notice: "Space was successfully created." }
        format.json { render :show, status: :created, location: @space }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /spaces/1
  def update
    authorize @space

    respond_to do |format|
      if @space.update(space_params)
        format.html { redirect_to  [current_organization, @space], notice: "Space was successfully updated." }
        format.json { render :show, status: :ok, location: @space }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @space.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /spaces/1
  def destroy
    authorize @space
    @space.destroy!

    respond_to do |format|
      format.html { redirect_to organization_spaces_path(current_organization), status: :see_other, notice: "Space was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # app/controllers/spaces_controller.rb
  def join
    @space = current_organization.spaces.find(params[:id])

    authorize @space, :join?

    if RuleEvaluator.new(@space.rule_sets, current_user).passes?
      SpaceMembership.find_or_create_by!(user: current_user, space: @space)
      redirect_to organization_space_path(current_organization, @space), notice: "You have successfully joined the space."
    else
      redirect_to organization_spaces_path(current_organization), alert: "You do not meet the requirements to join this space."
    end
  end

  def leave
    space = current_organization.spaces.find(params[:id])
    authorize space, :leave?
    space.members.delete(current_user)
    redirect_to organization_spaces_path(current_organization), notice: "You left #{space.name}."
  end


  private

    def set_space
      @space = current_organization.spaces.includes(posts: :rule_sets).find(params[:id])
    end

    def space_params
      params.require(:space).permit(:name, :description, rule_set_ids: [])
    end
end
