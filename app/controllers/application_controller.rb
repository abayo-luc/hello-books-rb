class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  include ExceptionHandler

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: 'Not found'
    }, status: :not_found
  end
  rescue_from ExceptionHandler::NotAuthorized do
    render json: {
     error: 'Not authorized'
    }, status: :not_authorized
  end

  private
    def authenticate_request
      token = request.headers['Authorization']
      decoded = WebToken.decode(token)
    rescue
      @current_user = nil
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    else
      @current_user = User.where(id: decoded['id'], email: decoded['email'])[0]
    end
end
