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
      @booking.notifications.create!({user_id: @listing.user_id, code: 0})
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
    @pending_json = @pending_bookings.map(&:to_builder)
      fail
    @confirmed_bookings = Booking.where(where_condition, @listing.id, 1, Date.today)
      .order("start_date ASC")
      .includes(:guest).to_a
      @confirmed_json = @confirmed_bookings.map(&:to_builder)
  end
  
  def accept
    @booking = Booking.find(params[:id])
    if @booking.change_status_to(1)
      @booking.notifications.create!({user_id: @booking.guest_id, code: 3})
      flash[:success] = "Booking has been accepted!"
    else
      flash[:errors] = [["This action is no longer available.  Please review the current status of your bookings"]]
    end
    @booking.overlapping_bookings.each do |other_booking|
      if other_booking.status == 0 && !other_booking.cancelled
        other_booking.change_status_to(2)
        other_booking.notifications.create!({user_id: other_booking.guest_id, code: 2})
      end
    end
    
    redirect_to listing_bookings_url(@listing)
  end
  
  def decline
    @booking = Booking.find(params[:id])
    if @booking.change_status_to(2)  
      @booking.notifications.create!({user_id: @booking.guest_id, code: 2})
      flash[:success] = "Booking has been declined!"
    else
      flash[:errors] = [["This action is no longer available.  Please review the current status of your bookings"]]
    end
    redirect_to listing_bookings_url(@listing)
  end
  
  def cancel
    @booking.cancel!
    if current_user.id == @booking.guest_id
      if @booking.status == 1
        @booking.notifications.create!({user_id: @listing.user_id, code: 1})
      elsif @booking.status == 0
        @booking.notifications.create!({user_id: @listing.user_id, code: 6})
      end
    elsif current_user.id == @listing.user_id
      @booking.notifications.create!({user_id: @booking.guest_id, code: 4})
    end
    if request.xhr?
      render json: @booking
    else
      flash[:success] = "Booking has been cancelled!"
      redirect_to :back
    end
  end
  
end
