class Api::V1::BooksController < ApplicationController
  before_action :authorize_admin, except: %i[index show]
  def index
    @books = Book.all
    render :index, status: :ok
  end
  def create
    @book = Book.new(book_params)
    if @book.save
      render :create, status: :created
    else
      render json: {
        message: 'Book registration Failed',
        errors: @book.errors
        }, status: :bad_request
    end
  end
  def update
    @book = find_book
    begin
      @book.update!(book_params)
      render :update, status: :ok
    rescue
      render json: {
        message: 'Updating book failed',
        errors: @book.errors
      }, status: :bad_request
    end
  end

  def show
    @book = find_book
    render :show, status: :ok
  end

  def destroy
    @book = find_book
    begin
      @book.destroy
      render json: {
        message: 'Book deletes successuflly'
      }, status: :no_content
    rescue => _e
      render json: {
        message: 'Deleting book failed',
        errors: @book.errors
      }, status: :bad_request
    end
 end

  private
    def find_book
      book = Book.find_by_id(params[:id])
      raise ActiveRecord::RecordNotFound unless book
      book
    end
    def book_params
      params.permit(:page_number,
        :title, :language, :category, :authors,
        :description, :isbn, :inventory,
        :published_at)
    end
end
