class BookingMailer < ActionMailer::Base
  default from: "notifications@sharebnb.com"
  
  def booking_email(notification)
    @user = notification.user
    @url_msg = notification.url_message
    @accept_url_msg = notification.accept_url_msg
    @decline_url_msg = notification.decline_url_msg
    mail(to: @user.email, subject: Booking.CODES[notification.code])
  end
end