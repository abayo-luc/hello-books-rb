class Api::V1::AuthorsController < ApplicationController
  before_action :authorize_admin, except: %i[index show]
  def index
    @authors = Author.all
    render :index, status: :ok
  end
  def create
    @author = Author.new(author_params)
    if @author.save
      render :create, status: :created
    else
      render json: {
        message: 'Author registration failed',
        errors: @author.errors
      }, status: :bad_request
    end
  end
  def show
    @author = find_author
    render :show, status: :ok
  end
  def update
    @author = find_author
    if @author.update(author_params)
      render :update, status: :ok
    else
      render json: {
        message: 'Action failed',
        errors: @author.errors
      }, status: :bad_request
    end
  end
  def destroy
    @author = find_author
    begin
      @author.destroy
    rescue => e
      render json: {
        message: 'Action failed',
        errors: [e.message]
      }, status: :bad_request
    else
      render json: {}, status: :no_content
    end
  end

  private
    def find_author
      author = Author.find_by_id params[:id]
      raise ActiveRecord::RecordNotFound unless author
      author
    end
    def author_params
      params.permit(:name, :country, :birth_date, :bio)
    end
end
