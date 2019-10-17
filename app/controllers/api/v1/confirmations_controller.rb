class Api::V1::ConfirmationsController < ApplicationController
  skip_before_action :authenticate_request
  def create
    @user = find_user_by_emial
    if @user.confirmed?
      render json: {
        message: 'Sending confirmaiton instructions failed',
        errors: ['Acount already verified']
      }, status: :bad_request
    else
      @user.send_reconfirmation_instructions
      render json: {
        message: 'Account confirmation instructions sent successuflly'
      }, status: :ok
    end
  end

  def update
    @user = find_user_by_token
    if @user.confirm
      render json: {
        message: 'Account confirmed successuflly'
      }, status: :ok
    else
      render json: {
        message: 'Account confirmation failed',
        errors: ['Acount already verified']
      }, status: :bad_request
    end
  end

  private
    def find_user_by_emial
      user = User.find_by(email: params[:email])
      raise ActiveRecord::RecordNotFound unless user

      user
    end

    def find_user_by_token
      user = User.find_by(confirmation_token: params[:token])
      raise ExceptionHandler::CustomError, 'Invalid or expired token' unless user

      user
    end
end
