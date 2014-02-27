class BookingMailer < ActionMailer::Base
  default from: "no-reply@sharebnb.com"
  
  def booking_email(notification)
    @user = notification.user
    @full_message = notification.message
    @url_msg = notification.url_message
    @accept_url_msg = notification.accept_url_msg
    @decline_url_msg = notification.decline_url_msg
    mail(to: @user.email, subject: Notification::CODES[notification.code])
  end
end