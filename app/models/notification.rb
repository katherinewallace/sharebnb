# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  noteworthy_id   :integer
#  noteworthy_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  new             :boolean          default(TRUE)
#  code            :integer          not null
#

class Notification < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :user_id, :noteworthy_id, :noteworthy_type, :code
  
  belongs_to :noteworthy, polymorphic: true
  belongs_to :user
  
  validates :user_id, :noteworthy_id, :noteworthy_type, :code, presence: true
  
  after_validation :send_email, on: :create
  
  CODES = {
    0 => "New booking request",
    1 => "Booking cancelled",
    2 => "Booking request declined",
    3 => "Booking confirmed",
    4 => "Booking cancelled",
    5 => "Welcome",
    6 => "Booking request cancelled"
  }

  def self.unread(user_id)
    Notification.where("user_id = ? AND new = true", user_id).count(:id)
  end
  
  def url_message
    case code
    when 0, 1, 6
      ["Manage my listing", listing_bookings_url(self.user.listing)]
    when 2,3,4
      ["View my trips", user_trips_url(self.user)]
    else
      ["Explore!", root_url]
    end
    
  end
  
  def accept_url_msg
    if self.code == 0
      ["Accept this booking", "#{accept_booking_url(self.noteworthy)}/?host=#{self.noteworthy.owner_token}"]
    end
  end
  
  def decline_url_msg
    if self.code == 0
      ["Decline this booking", decline_booking_url(self.noteworthy)]
    end
  end
  
  def message
    booking = self.noteworthy
    case code
    when 0
      "#{booking.guest.full_name} has requested to book your space from #{booking.start_date} to #{booking.end_date}"
    when 1
      "#{booking.guest.full_name} has cancelled their booking from #{booking.start_date} to #{booking.end_date}"
    when 2
      "#{booking.host.full_name} has declined your booking for #{booking.listing.title}"
    when 3
      "#{booking.host.full_name} has accepted your booking for #{booking.listing.title}"
    when 4
       "#{booking.host.full_name} has cancelled your booking for #{booking.listing.title}"
    when 5
       "Welcome to sharebnb!"
    when 6
      "#{booking.guest.full_name} has cancelled their booking request"
    else
      ""
    end
  end
  
  def send_email
    if self.code <= 6 
      msg = BookingMailer.booking_email(self)
      msg.deliver!
    end
  end
  
end
