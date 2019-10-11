class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user
  include ExceptionHandler

  def authorize_admin
    unless current_user&.super_admin? || current_user&.admin?
      raise ExceptionHandler::NotAuthorized
    end
  end

  def is_super_admin?
    raise ExceptionHandler::NotAuthorized unless current_user&.super_admin?
  end

  rescue_from ActiveRecord::RecordNotFound do
    render json: {
      error: 'Record not found'
    }, status: :not_found
  end

  rescue_from ExceptionHandler::NotAuthorized do
    render json: {
      error: 'You are not authorized to perfom this action'
    }, status: :forbidden
  end
  rescue_from ExceptionHandler::CustomError do |e|
    render json: {
      message: 'Action failed',
      errors: [e.message]
    }, status: :bad_request
  end

  rescue_from ExceptionHandler::NotConfirmed do
    render json: {
      message: 'Please verify your account first!'
    }, status: :forbidden
  end

  private
    def authenticate_request
      token = request.headers['Authorization']
      decoded = WebToken.decode(token)
    rescue StandardError
      @current_user = nil
      unless @current_user
        render json: { error: 'The user must provide a
           valid token to authenticate' },
               status: 401
      end
    else
      user = User.where(id: decoded['id'],
                        email: decoded['email'])[0]
      raise ExceptionHandler::NotConfirmed unless user&.confirmed?

      @current_user = user
    end
end
