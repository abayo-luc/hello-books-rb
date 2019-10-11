class Api::V1::ProfilesController < ApplicationController
  def index
    @profiles = User.all
    render :index, status: :ok
  rescue => e
    raise ExceptionHandler::CustomError, e.message
  end

  def show
    @profile = User.find_by_id params[:id]
    raise ActiveRecord::RecordNotFound unless @profile
    render :show, status: :ok
  end
end
