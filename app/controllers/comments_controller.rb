class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_thread_post
  before_action :set_comment, only: [ :destroy ]

  # GET /thread_posts/:thread_post_id/comments
  def index
    @comments = @thread_post.comments
    render json: @comments
  end

  # POST /thread_posts/:thread_post_id/comments
  def create
    @comment = @thread_post.comments.build(comment_params)
    @comment.user_id = params[:user_id] if params[:user_id]
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /thread_posts/:thread_post_id/comments/:id
  def destroy
    @comment.destroy
    head :no_content
  end

  private
    def set_thread_post
      @thread_post = ThreadPost.find(params[:thread_post_id])
    end

    def set_comment
      @comment = @thread_post.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:user_id, :content, :parent_id)
    end
end
