class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  include ExceptionHandler

  private
    def authenticate_request
      token = request.headers['Authorization']
      decoded = WebToken.decode(token)
    rescue
      @current_user = nil
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    else
      @current_user = User.where(id: decoded['id'], email: decoded['email'])
    end
end
