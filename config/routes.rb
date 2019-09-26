Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/', to: 'application#index'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      resource :users, only: %i[create]
      resource :sessions, only: %i[create destroy show]
      put '/users/:id/roles', to: 'roles#update'
    end
  end
end
