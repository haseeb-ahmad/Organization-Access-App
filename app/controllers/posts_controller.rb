class PostsController < ApplicationController
  before_action :set_space
  before_action :set_post, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[index new]
  after_action :verify_policy_scoped, only: %i[index]

  def index
    @posts = policy_scope(@space.posts.includes(:author))
  end

  def show
    authorize @post
  end

  def new
    @post = @space.posts.build(author: current_user)
    authorize @post
  end

  def create
    @post = @space.posts.build(post_params.merge(author: current_user))
    authorize @post

    if @post.save
      redirect_to [current_organization, @space, @post], notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @post
  end

  def update
    authorize @post
    if @post.update(post_params)
      redirect_to [current_organization, @space, @post], notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post
    @post.destroy
    redirect_to organization_space_posts_path(current_organization, @space), notice: "Post was successfully deleted."
  end

  private

  def set_space
    set_current_organization
    @space = current_organization.spaces.find(params[:space_id])
  end

  def set_post
    @post = @space.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, rule_set_ids: [])
  end
end
