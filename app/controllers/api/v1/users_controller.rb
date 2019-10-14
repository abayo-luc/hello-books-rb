class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]
  def create
    @user = User.new(user_params)
    if @user.save
      render :create, status: :created
    else
      render json: {
        message: 'User registration faild',
        errors: @user.errors
      }, status: :bad_request
    end
  end
  def show
    render json: {
      message: 'Success',
      data: @current_user
    }
  end

  private
    def user_params
      params.permit(:email, :password, :first_name, :last_name)
    end
end
