Sharebnb::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  resources :listings
  root to: "static_pages#home"
end
