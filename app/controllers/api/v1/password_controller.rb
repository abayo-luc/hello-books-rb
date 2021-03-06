class Api::V1::PasswordController < ApplicationController
  skip_before_action :authenticate_request
  def create
    @user = User.find_by(email: reset_params[:email])
    raise ActiveRecord::RecordNotFound unless @user

    begin
      @user.send_reset_password_instructions
    rescue => e
      render json: {
        message: 'Sending reset password instructions failed',
        errors: [e.message]
      }, status: :bad_request
    else
      render json: {
        message: 'Reset password instructions sent successuflly'
      }, status: :ok
    end
  end

  def update
    @user = find_user_by_token
    raise 'Invalid or expired token' unless @user&.reset_password_period_valid?

    if @user.reset_password(update_params['password'], update_params['password_confirmation'])
      render json: {
        message: 'Password updated successfully'
      }, status: :ok
    else
      raise @user.errors.full_messages[0].to_s
    end
  rescue StandardError => e
    render json: {
      errors: [e.message]
    }, status: :bad_request
  end

  private
    def find_user_by_token
      User.find_by(reset_password_token: params[:token])
    end

    def reset_params
      params.permit(:email)
    end

    def update_params
      params.permit(:password, :password_confirmation, :token)
    end
end
