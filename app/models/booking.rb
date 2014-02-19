# == Schema Information
#
# Table name: bookings
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  guest_id   :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :integer          default(0)
#  cancelled  :boolean          default(FALSE)
#  subtotal   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Booking < ActiveRecord::Base
  
  STATUS = {
    0 => :pending,
    1 => :accepted,
    2 => :declined
  }
  
  attr_accessible :start_date, :end_date
  
  validates :guest_id, :listing_id, presence: true
  validates :start_date, presence: {message: "Please select a check-in date"}
  validates :end_date, presence: {message: "Please select a check-out date"}
  validate :valid_range
  validate :availability, on: :create
  validate :valid_start_date
  
  after_initialize :calculate_subtotal
  
  belongs_to :listing
  belongs_to :guest, class_name: "User"
  
  def change_status_to(new_status)
    if self.status == 0 && !self.cancelled
      self.status = new_status;
      self.save!
      return true
    else
      return false
    end
  end
  
  def cancel!
    self.cancelled = true
    self.save!
  end
  
  def calculate_subtotal
    self.subtotal = (self.end_date - self.start_date) * self.listing.price
  end
  
  def valid_start_date
    if self.start_date < Date.today
      errors[:start_date] << "A booking cannot be for a date in the past"
    end
  end
  
  def valid_range
    unless self.end_date > self.start_date
      errors[:base] << "Invalid date range"
    end
  end
  
  def availability
    unless self.within_date_range? && !self.overlapping_approved_bookings?
      errors[:base] << "The apartment is not available for that set of dates"
    end
  end
  
  def within_date_range?
    where_condition = <<-SQL
     listing_id = ? 
     AND (? BETWEEN start_date AND end_date) 
     AND (? BETWEEN start_date AND end_date)
    SQL
    ranges = DateRange.where(where_condition, self.listing_id, self.start_date, self.end_date)
    ranges.any?
  end
  
  def overlapping_approved_bookings?
    overlapping_bookings.any? { |request| request.status == 1 && !request.cancelled }
  end
  
  def overlapping_bookings
    where_condition = <<-SQL
      id != (CASE WHEN ? IS NULL THEN 0 ELSE ? END)
      AND listing_id = ?
      AND ( ? BETWEEN start_date AND end_date OR ? BETWEEN start_date AND end_date )
    SQL
    overlaps = Booking.where(where_condition, self.id, self.id, self.listing_id, self.start_date, self.end_date)
  end
  
end
