class Api::V1::ProfilesController < ApplicationController
  before_action :authorize_admin, only: %i[show index]
  def index
    @profiles = User.all
    render :index, status: :ok
  rescue => e
    raise ExceptionHandler::CustomError, e.message
  end

  def show
    @profile = find_profile
    render :show, status: :ok
  end

  def update
    @profile = @current_user
    if @profile.update!(profile_attributes)
      render :update, status: :ok
    end
    rescue => e
      render json: {
        message: e.message,
        errors: @profile.errors
      }, status: :bad_request
  end

  private
    def find_profile
      profile = User.find_by_id params[:id]
      raise ActiveRecord::RecordNotFound unless profile
      profile
    end

    def profile_attributes
      params.permit(:first_name, :last_name, :description, :phone_number, :address)
    end
end
