Rails.application.routes.draw do
  devise_for :users, skip: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/', to: 'application#index'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do 
      resource :users, only: %i[create] do 
        put '/:id/roles', to: 'roles#update'
        post '/login', to: 'sessions#create'
        post '/password', to: 'password#create'
        put '/password', to: 'password#update', as: :edit_password
      end
      #books
      get '/books', to: 'books#index'
      get '/books/:id', to: 'books#show'
      post '/books', to: 'books#create'
      put '/books/:id', to: 'books#update'
      delete '/books/:id', to: 'books#destroy'
      #categories
      get '/categories', to: 'categories#index'
      post'/categories', to: 'categories#create'
      delete '/categories/:id', to: 'categories#destroy'
    end
  end
end
