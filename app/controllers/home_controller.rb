class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @thread_posts = ThreadPost.includes(:user)
                              .order(created_at: :desc)
                              .page(params[:page])
                              .per(params[:per_page] || 20)
  end
end
