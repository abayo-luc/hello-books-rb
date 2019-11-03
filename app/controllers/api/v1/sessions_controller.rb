class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create]
  def create
    user = User.find_by email: params[:email]
    raise ExceptionHandler::NotConfirmed unless user&.confirmed?
    if user&.valid_password?(params[:password])
      jwt = WebToken.encode(user)
      render :create, status: :ok, locals: { token: jwt }
    else
      raise 'Invalid email or password'
    end
  end
end
