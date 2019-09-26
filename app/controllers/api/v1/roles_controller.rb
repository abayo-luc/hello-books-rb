class Api::V1::RolesController < ApplicationController
  before_action :check_super_admin
  def update
    @user = User.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound, 'Record not found' unless @user
    begin
      @user.change_role(role_params[:role])
      render :make_admin, status: 200
    rescue => e
      render json: {
        error: e.message
      }, status: :bad_request
    end
  end

  private
    def role_params
      params.permit(:role, :id)
    end
    def check_super_admin
      raise ExceptionHandler::NotAuthorized unless current_user&.super_admin?
    end
end
