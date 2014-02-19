class BookingsController < ApplicationController
  
  before_filter :require_signed_in
  
  def create
    @listing = Listing.find(params[:listing_id])
    @booking = @listing.bookings.new(params[:booking])
    @booking.guest_id = current_user.id
    if @booking.save
      flash[:success] = "Your booking has been requested.  The host will review and accept or decline your booking request."
      redirect_to user_trips_url(current_user)
    else
      flash.now[:errors] = @booking.errors.messages.values
      render "listings/show"
    end
  end
  
  def trips
    @bookings = current_user.bookings.includes(:listing).sort!{|a, b| a.start_date <=> b.start_date}
  end
  
  def index
    
  end
  
end
