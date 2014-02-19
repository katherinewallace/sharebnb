Sharebnb::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  get "users/:id/bookings", { as: :user_trips, controller: :bookings, action: :trips }
  
  resources :listings do
    resource :bookings, only: [:create]
  end
  get "listings/:id/calendar", { as: :listing_calendar, controller: :listings, action: :calendar }
  root to: "static_pages#home"
end
