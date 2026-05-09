class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [:login]

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { 
        token: token, 
        user: { 
          id: @user.id,
          email: @user.email, 
          name: @user.name
        } 
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end