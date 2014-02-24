class BookingsController < ApplicationController
  
  before_filter :require_signed_in
  before_filter :require_listing_owner, only: [:index]
  before_filter :require_host, only: [:accept, :decline]
  before_filter :require_host_or_guest, only: [:cancel] 
  
  def create
    @listing = Listing.find(params[:listing_id])
    @booking = @listing.bookings.new(params[:booking])
    @booking.guest_id = current_user.id
    if @booking.save
      flash[:success] = "Your booking has been requested.  The host will review and accept or decline your booking request."
      @listing.notifications.create!({user_id: @listing.user_id, title: "#{current_user.full_name} has requested to book your space from #{@booking.start_date} to #{@booking.end_date}"})
      redirect_to user_trips_url(current_user)
    else
      flash[:errors] = @booking.errors.messages.values
      redirect_to listing_url(@listing)
    end
  end
  
  def trips
    @bookings = current_user.bookings.where("end_date >= ?", Date.today)
      .order("start_date ASC")
      .includes(:listing)
  end
  
  def index
    @listing = Listing.find(params[:listing_id])
    where_condition = <<-SQL
      listing_id = ? AND status = ? AND cancelled = false AND end_date >= ?
    SQL
    @pending_bookings = Booking.where(where_condition, @listing.id, 0, Date.today)
      .order("start_date ASC")
      .includes(:guest).to_a
    @confirmed_bookings = Booking.where(where_condition, @listing.id, 1, Date.today)
      .order("start_date ASC")
      .includes(:guest).to_a
  end
  
  def accept
    @booking = Booking.find(params[:id])
    @booking.change_status_to(1)
    @booking.overlapping_bookings.each { |other_booking| other_booking.change_status_to(2) }
    @booking.notifications.create!({user_id: @booking.guest_id, title: "#{current_user.full_name} has accepted your booking for #{@listing.title}"})
    flash[:success] = "Booking has been accepted!"
    redirect_to listing_bookings_url(@listing)
  end
  
  def decline
    @booking = Booking.find(params[:id])
    @booking.change_status_to(2)
    @booking.notifications.create!({user_id: @booking.guest_id, title: "#{current_user.full_name} has declined your booking for #{@listing.title}"})
    flash[:success] = "Booking has been declined!"
    redirect_to listing_bookings_url(@listing)
  end
  
  def cancel
    @booking.cancel!
    if current_user.id == @booking.guest_id
      @booking.notifications.create!({user_id: @listing.user_id, title: "#{current_user.full_name} has cancelled their booking from #{@booking.start_date} to #{@booking.end_date}"})
    elsif current_user.id == @listing.user_id
      @listing.notifications.create!({user_id: @booking.guest_id, title: "#{current_user.full_name} has cancelled your booking for #{@listing.title}"})
    end
    flash[:success] = "Booking has been cancelled!"
    redirect_to :back
  end
  
end
