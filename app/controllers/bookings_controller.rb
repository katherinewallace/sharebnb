class BookingsController < ApplicationController
  
  before_filter :require_signed_in
  before_filter :require_listing_owner, only: [:index]
  
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
    sort_by_date!(@bookings = current_user.bookings.includes(:listing))
  end
  
  def index
    @listing = Listing.find(params[:listing_id])
    @pending_bookings = Booking.where("listing_id = ? AND status = 0", @listing.id).includes(:guest).to_a
    sort_by_date!(@pending_bookings)
    @confirmed_bookings = Booking.where("listing_id = ? AND status = 1", @listing.id).includes(:guest).to_a
    sort_by_date!(@confirmed_bookings)
  end
  
  def accept
    @booking = Booking.find(params[:id])
    @listing = @booking.listing
    @booking.change_status_to(1)
    @booking.overlapping_bookings.each { |other_booking| other_booking.change_status_to(2) }
    flash[:success] = "Booking has been accepted!"
    redirect_to listing_bookings_url(@listing)
  end
  
  def decline
    @booking = Booking.find(params[:id])
    @listing = @booking.listing
    @booking.change_status_to(2)
    flash[:success] = "Booking has been declined!"
    redirect_to listing_bookings_url(@listing)
  end
  
  private
  
  def sort_by_date!(array)
    array.sort!{|a, b| a.start_date <=> b.start_date}
  end
  
end
