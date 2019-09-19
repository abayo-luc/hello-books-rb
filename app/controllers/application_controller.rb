class ApplicationController < ActionController::API
  def index
    render json: { "message":  "Welcome to Hello-Books API" }
  end
end
