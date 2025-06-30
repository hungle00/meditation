class ThreadPostsController < ApplicationController
  before_action :authenticate_request!, except: [ :index, :show ]
  before_action :set_thread_post, only: [ :show, :update, :destroy ]
  skip_before_action :verify_authenticity_token

  # GET /thread_posts
  def index
    @thread_posts = ThreadPost.all
    render json: @thread_posts
  end

  # GET /thread_posts/:id
  def show
    render json: @thread_post
  end

  # POST /thread_posts
  def create
    @thread_post = ThreadPost.new(thread_post_params)
    if @thread_post.save
      render json: @thread_post, status: :created
    else
      render json: @thread_post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /thread_posts/:id
  def update
    if @thread_post.update(thread_post_params)
      render json: @thread_post
    else
      render json: @thread_post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /thread_posts/:id
  def destroy
    @thread_post.destroy
    head :no_content
  end

  private
    def set_thread_post
      @thread_post = ThreadPost.find(params[:id])
    end

    def thread_post_params
      params.require(:thread_post).permit(:user_id, :title, :content)
    end
end
