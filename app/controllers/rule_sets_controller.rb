class RuleSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organization!
  before_action :set_rule_set, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized, except: [:index, :new]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @rule_sets = policy_scope(current_organization.rule_sets)
  end

  def show
  end

  def new
    @rule_set = current_organization.rule_sets.new
  end

  def create
    @rule_set = current_organization.rule_sets.new(rule_set_params)
    authorize @rule_set

    if @rule_set.save
      redirect_to [current_organization, @rule_set], notice: "Rule set created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @rule_set.update(rule_set_params)
      redirect_to [current_organization, @rule_set], notice: "Rule set updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @rule_set.destroy
    redirect_to rule_sets_path, notice: "Rule set deleted successfully."
  end

  private

  def set_rule_set
    @rule_set = current_organization.rule_sets.find(params[:id])
    authorize @rule_set
  end

  def rule_set_params
    params.require(:rule_set).permit(:name, :rule_type, rules_attributes: [:id, :field, :operator, :value, :_destroy])
  end
end
