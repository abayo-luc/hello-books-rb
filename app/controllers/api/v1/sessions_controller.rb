class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]
  def create
    user = User.find_by email: params[:email]
    if user&.valid_password?(params[:password])
      jwt = WebToken.encode(user)
      render :create, status: :ok, locals: { token: jwt }
    else
      render json: {
          error: 'Invalid email or password'
      }, status: :bad_request
    end
    rescue => e
      render json: {
         error: e.message
     }, status: :bad_request
  end
end
