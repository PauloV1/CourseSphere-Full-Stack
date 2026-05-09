class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create]
  before_action :authorize_request, only: [:me]

  def me
    render json: { 
      user: { 
        id: @current_user.id, 
        email: @current_user.email, 
        name: @current_user.name 
      } 
    }, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { 
        token: token,
        user: { 
          id: user.id,
          email: user.email, 
          name: user.name 
        } 
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end