Sharebnb::Application.routes.draw do
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
  
  get "/users/:id/bookings", { as: :user_trips, controller: :bookings, action: :trips }
  
  resources :listings do
    resources :bookings, only: [:create, :index]
  end
  get "/bookings/:id/accept", { as: :accept_booking, controller: :bookings, action: :accept }
  get "/bookings/:id/decline", { as: :decline_booking, controller: :bookings, action: :decline }
  get "/listings/:id/calendar", { as: :listing_calendar, controller: :listings, action: :calendar }
  get "/bookings/:id/cancel", { as: :cancel_booking, controller: :bookings, action: :cancel }
  root to: "static_pages#home"
end
