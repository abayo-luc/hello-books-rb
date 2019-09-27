class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  include ExceptionHandler

  def authorize_admin
    raise ExceptionHandler::NotAuthorized unless current_user&.super_admin? || current_user&.admin?
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: 'Not found'
    }, status: :not_found
  end
  rescue_from ExceptionHandler::NotAuthorized do
    render json: {
     error: 'You are not authorized to perfom this action'
    }, status: :forbidden
  end

  private
    def authenticate_request
      token = request.headers['Authorization']
      decoded = WebToken.decode(token)
    rescue
      @current_user = nil
      render json: { error: 'The user must provide a
         valid token to authenticate' },
         status: 401 unless @current_user
    else
      @current_user = User.where(id: decoded['id'],
        email: decoded['email']
        )[0]
    end
end
