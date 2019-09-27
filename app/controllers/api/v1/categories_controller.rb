class Api::V1::CategoriesController < ApplicationController
  before_action :is_super_admin?, only: %i[create destroy]
  def index
    @categories = Category.all
    render :index, status: :ok
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render :create, status: :created
    else
      render json: {
        message: 'Creating new category failed',
        errors: @category.errors
      }, status: :bad_request
    end
  end

  def destroy
    category = Category.find_by_id(params[:id])
    raise ActiveRecord::RecordNotFound unless category
    category.destroy
    render json: {
      message: 'Category remove successuflly'
    }, status: :ok
  end

  private
    def category_params
      params.permit(:name)
    end
end
