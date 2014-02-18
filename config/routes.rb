Sharebnb::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  resources :listings
  get "listings/:id/calendar", {as: :listing_calendar, controller: :listings, action: :calendar}
  root to: "static_pages#home"
end
