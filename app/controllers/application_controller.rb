class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SessionsHelper
  
  def login(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    @current_user = user
  end
  
  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
    clear_return_to
  end
  
  def remember_location
    session[:return_to] =  request.url.gsub(/\/bookings/, "")
  end
  
  def redirect_back_or_home
    redirect_to(session[:return_to] || root_url)
    clear_return_to
  end
  
  def clear_return_to
    session.delete(:return_to)
  end
  
  def require_signed_in
    unless current_user
      remember_location
      redirect_to new_session_url
    end
  end
  
  def require_listing_owner
   
    @listing = params[:listing_id] ? Listing.find(params[:listing_id]) : Listing.find(params[:id])
    unless current_user && @listing.user_id == current_user.id
      flash[:errors] = [["Please make sure you are signed in with the correct account and then click the link to 'Your Listing'"]]
      begin
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to listing_url(@listing)
      end
    end
  end
  
  def only_allow_one_listing
    existing_listing = current_user.listing
    if existing_listing
      redirect_to listing_bookings_url(existing_listing)
    end
  end
  
  def require_host
    @booking = Booking.find(params[:id])
    @listing = @booking.listing
    unless current_user.id == @listing.user_id || params[:host] == @booking.owner_token
      flash[:errors] = [["Please make sure you are signed in with the correct account and then click the link to 'Your Listing'"]]
      begin 
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_url
      end
    end
  end
  
  def require_host_or_guest
    @booking = Booking.find(params[:id])
    @listing = @booking.listing
    unless current_user.id == @booking.guest_id || 
      current_user.id == @listing.user_id
      begin 
        redirect_to :back
      rescue ActionController::RedirectBackError
        redirect_to root_url
      end
    end
  end
end
