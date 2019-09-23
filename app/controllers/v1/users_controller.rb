class V1::UsersController < ApplicationController
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

  private
    def user_params
      params.permit(:email, :password, :first_name, :last_name)
    end
end
