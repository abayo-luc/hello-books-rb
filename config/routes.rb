Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/', to: 'application#index'
  namespace :v1, defaults: {format: :json} do
      resource :users, only: %i[create]
      resource :sessions, only: %i[create destroy show]
  end
end
