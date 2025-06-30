class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected
    def authenticate_request!
      header = request.headers["Authorization"]
      header = header.split(" ").last if header
      begin
        decoded = JWT.decode(header, Rails.application.credentials.secret_key_base)[0]
        @current_user = User.find(decoded["user_id"])
      rescue
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def current_user
      @current_user
    end
end
