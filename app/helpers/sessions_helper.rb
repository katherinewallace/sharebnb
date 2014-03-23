module SessionsHelper
  
  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by_session_token(session[:session_token])
  end
  
  def update_demo
    demo_user = User.find_by_email("demo@example.com")
    demo_listing = demo_user.listing
    start_date = demo_listing.date_ranges.pluck(:start_date).first
    demo_listing.bookings.where("status != 0").destroy_all
    demo_user.notifications.where("code != 5").destroy_all
    (0..2).each do |num| 
      guest = User.all.sample
      booking = Booking.new({start_date: (start_date + num.weeks), end_date: (start_date + (1.5 * num).weeks + 1.day), guest_num: 1})
      booking.guest_id = guest.id
      booking.listing_id = demo_listing.id
      booking.save!
    end
  end
  
end