class Api::V1::BooksController < ApplicationController
  before_action :authorize_admin, except: %i[index show]
  def index
    @books = Book.find_all(category: params[:category])
    render :index, status: :ok
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      add_categories(@book)
      render :create, status: :created
    else
      render json: {
        message: 'Book registration Failed',
        errors: @book.errors
      }, status: :bad_request
    end
  rescue StandardError
    raise ExceptionHandler::CustomError, 'Categories should be an array of strings'
  end

  def update
    @book = find_book
    begin
      @book.update!(book_params)
      add_categories(@book)
      render :update, status: :ok
    rescue StandardError
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
    rescue StandardError => _e
      render json: {
        message: 'Deleting book failed',
        errors: @book.errors
      }, status: :bad_request
    end
 end

  private
    def add_categories(book)
      categories = Category.find_categories(params[:categories] || [])
      book.categories << categories if categories.size >= 1
    end
    def find_book
      book = Book.find_by_id(params[:id])
      raise ActiveRecord::RecordNotFound unless book

      book
    end

    def book_params
      params.permit(:page_number,
                    :title, :language, :categories, :authors,
                    :description, :isbn, :inventory,
                    :published_at)
    end
end
