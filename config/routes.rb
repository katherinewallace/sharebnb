Sharebnb::Application.routes.draw do
  resources :users, only: [:new, :create, :edit, :update]
  
  resources :notifications, only: [:index]
  
  resource :session, only: [:new, :create, :destroy]
  
  get "/users/:id/bookings", { as: :user_trips, controller: :bookings, action: :trips }
  
  get "auth/facebook/callback" => "sessions#create"
  
  resources :listings do
    resources :bookings, only: [:create, :index]
    resources :photos, only: [:new, :create, :index]
  end
  
  resources :photos, only: :destroy
  resources :bookings, only: :update
  
  get "/bookings/:id/accept", { as: :accept_booking, controller: :bookings, action: :accept }
  get "/bookings/:id/decline", { as: :decline_booking, controller: :bookings, action: :decline }
  get "/listings/:id/calendar", { as: :listing_calendar, controller: :listings, action: :calendar }
  get "/bookings/:id/cancel", { as: :cancel_booking, controller: :bookings, action: :cancel }
  get "/photos/:id/primary", { as: :primary_photo, controller: :photos, action: :primary }
  
  root to: "static_pages#home"
end
