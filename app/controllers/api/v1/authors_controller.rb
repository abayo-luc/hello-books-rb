class Api::V1::AuthorsController < ApplicationController
  def index
    @authors = Author.all
    render :index, status: :ok
  end
end
