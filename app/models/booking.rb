# == Schema Information
#
# Table name: bookings
#
#  id            :integer          not null, primary key
#  listing_id    :integer          not null
#  guest_id      :integer          not null
#  start_date    :date             not null
#  end_date      :date             not null
#  status        :integer          default(0)
#  cancelled     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price         :integer
#  guest_num     :integer          not null
#  date_range_id :integer          not null
#  owner_token   :string(255)
#

class Booking < ActiveRecord::Base
  
  STATUS = {
    0 => :pending,
    1 => :accepted,
    2 => :declined
  }
  
  attr_accessible :start_date, :end_date, :guest_num
  
  validates :guest_id, :listing_id, presence: true
  validates :start_date, presence: { message: "Please select a check-in date" }
  validates :end_date, presence: { message: "Please select a check-out date" }
  validates :guest_num, presence: { message: "Please select the number of guests" }
  validate :valid_range
  validate :availability, on: :create
  validate :valid_start_date, on: :create
  validate :accomodates_guests
  
  before_validation :assign_price, on: :create
  before_validation :assign_date_range, on: :create
  after_validation :assign_owner_token, on: :create
  
  belongs_to :listing
  
  belongs_to :guest, class_name: "User"
  has_one :host, through: :listing, source: :user
  has_many :notifications, as: :noteworthy, dependent: :destroy
  
  def change_status_to(new_status)
    if self.status == 0 && !self.cancelled
      self.status = new_status;
      self.owner_token = nil
      self.save!
      return true
    else
      return false
    end
  end
  
  def assign_price
    self.price = self.listing.price
  end
  
  def assign_date_range
    where_condition = <<-SQL
     listing_id = ? 
     AND (? BETWEEN start_date AND end_date) 
     AND (? BETWEEN start_date AND end_date)
    SQL
    self.date_range_id = DateRange.where(where_condition, self.listing_id, self.start_date, self.end_date).pluck(:id).first
  end
  
  def assign_owner_token
    self.owner_token ||= SecureRandom::urlsafe_base64
  end
  
  def cancel!
    self.cancelled = true
    self.save!
  end
  
  def subtotal
    price = self.price ? self.price : self.listing.price
    Integer(self.end_date - self.start_date) * price 
  end
  
  def accomodates_guests
    if self.guest_num > self.listing.guests
      errors[:guest_num] << "This space cannot accomodate that many guests"
    end
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
    unless self.date_range_id && !self.overlapping_approved_bookings?
      errors[:base] << "This space is not available for that set of dates"
    end
  end
  
  def overlapping_approved_bookings?
    overlapping_bookings.any? { |request| request.status == 1 }
  end
  
  def overlapping_bookings
    where_condition = <<-SQL
      id != (CASE WHEN ? IS NULL THEN 0 ELSE ? END)
      AND listing_id = ?
      AND cancelled = false
      AND status != 2
      AND ( (? >= start_date AND ? < end_date) OR (? > start_date AND ? <= end_date) )
    SQL
    overlaps = Booking.where(where_condition, self.id, self.id, self.listing_id, self.start_date, self.start_date, self.end_date, self.end_date)
  end
  
  def to_builder
    Jbuilder.new do |booking|
      booking.start_date = self.start_date
      booking.end_date = self.end_date
      booking.guest_num = self.guest_num
      booking.status = self.status
      booking.subtotal = self.subtotal
      booking.guest_fname = self.guest.fname
      booking.guest_lname = self.guest.lname
      booking.guest_pic_url = self.guest.profile_pic.url(:small)
     end
  end
end
