Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/signup', to: 'users#create'
  post '/login', to: 'authentication#login'
  delete '/logout', to: 'authentication#logout'
  #get "up" => "rails/health#show", as: :rails_health_check
  get '/me', to: 'users#me'

  resources :courses do
    resources :lessons, only: [:index, :create]
  end
  resources :lessons, only: [:show, :update, :destroy]
end
