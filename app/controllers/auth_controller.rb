class AuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /register
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = encode_jwt(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def encode_jwt(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base)
    end
end
