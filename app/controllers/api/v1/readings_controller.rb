class Api::V1::ReadingsController < ApplicationController
  before_action :authorize_admin, only: %i[update]
  def index
    @readings = Reading.where(user_id: @current_user.id)
    render :index, status: :ok
  end
  def create
    book = find_book
    @reading = Reading.create(user_id: @current_user.id, book_id: book.id)
    if @reading.save
      render :create, status: :created
    else
      render json: {
          message: 'Action failed',
          errors: @reading.errors
      }, status: :bad_request
    end
  end
  def update
    @reading = find_reading
    if @reading.borrow!
      render json: {
          message: "Marked #{@reading.status} successuflly"
      }, status: :ok
    else
      render json: {
          message: 'Action failed, please try again'
      }, status: :bad_request
    end
  end
  def destroy
    reading = find_reading
    reading.destroy!
    render json: {}, status: :no_content
    rescue
      render json: {
          message: 'Action failed, please try again'
      }, status: :bad_request
  end

  private
    def find_book
      book = Book.find_by_id params[:book_id]
      raise ActiveRecord::RecordNotFound unless book
      book
    end
    def find_reading
      reading = Reading.find_by(book_id: params[:book_id], user_id: @current_user.id)
      raise ActiveRecord::RecordNotFound unless reading
      reading
    end
end
