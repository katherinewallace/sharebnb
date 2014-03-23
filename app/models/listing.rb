# == Schema Information
#
# Table name: listings
#
#  id           :integer          not null, primary key
#  room_type    :integer
#  guests       :integer
#  bedrooms     :integer
#  bathrooms    :integer
#  city         :string(255)
#  neighborhood :string(255)
#  address      :string(255)
#  price        :integer
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          not null
#  zip          :string(255)
#  title        :string(255)      not null
#  latitude     :float
#  longitude    :float
#

class Listing < ActiveRecord::Base
  
  ROOM_TYPES = {
    0 => "entire house/apt",
    1 => "private room",
    2 => "shared room"
  }
  
  attr_accessible :room_type, :guests, :bedrooms, :bathrooms, :city, :neighborhood, 
    :address, :zip, :price, :description, :user_id, :title, :latitude, :longitude
    
  validates :user_id, presence: true
  validates :title, presence: {message: "Title cannot be blank"}
  validates :room_type, presence: { message: "You must choose a room type" }
  validates :guests, presence: { message: "You must indicate how many guests your space accomodates" }
  validates :bedrooms, presence: { message: "You must choose the number of bedrooms" }
  validates :bathrooms, presence: { message: "You must choose the number of bathrooms" }
  validates :city, presence: { message: "You must choose the city where your space is located" }
  validates :neighborhood, presence: { message: "Neighborhood cannot be blank" }
  validates :address, presence: { message: "Address cannot be blank"}
  validates :zip, format: { with: /^\d{5}(?:[-\s]\d{4})?$/, message: "You must enter a valid zipcode" }
  validates :price, numericality: { greater_than_or_equal_to: 0, 
    less_than_or_equal_to: 5000, message: "You must enter a price between $0 and $5000 a night" }
  
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?
  
  belongs_to :user
  has_many :date_ranges, inverse_of: :listing, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :photos, inverse_of: :listing, dependent: :destroy
  has_many :notifications, as: :noteworthy
  
  def self.filter(params)
    results = Listing
    
    if(params[:start_date].present? || params[:end_date].present?)
      results = results.joins(:date_ranges)
    end
    
    start_where_condition = <<-SQL
      (? BETWEEN date_ranges.start_date AND date_ranges.end_date) AND
      listings.id NOT IN (
        SELECT listing_id
        FROM bookings
        WHERE bookings.status = 1 AND bookings.cancelled = false AND (? >= bookings.start_date) AND (? < bookings.end_date)
        )
    SQL
    
    end_where_condition = <<-SQL
    (? BETWEEN date_ranges.start_date AND date_ranges.end_date) AND
    listings.id NOT IN (
      SELECT listing_id
      FROM bookings
      WHERE bookings.status = 1 AND bookings.cancelled = false AND (? > bookings.start_date) AND (? <= bookings.end_date)
      )
    SQL
    
    if(params[:start_date].present?)
      results = results.where(start_where_condition, params[:start_date], params[:start_date], params[:start_date])
    end
    
    if(params[:end_date].present?)
      results = results.where(end_where_condition, params[:end_date], params[:end_date], params[:end_date])
    end
    
    if(params[:guest_num].present?)
      results = results.where("guests >= ?", params[:guest_num])
    end
    
    if(params[:city].present?)
      results = results.where(city: params[:city])
    end
    
    results.all
    
  end
  
  def primary_photo_file
    photos = self.photos
    if photos.any?
      primary = photos.find { |photo| photo.primary }
      primary ? primary.photo_file : photos.first.photo_file
    else
      Photo.new.photo_file
    end
  end
  
  def active_bookings
    Booking.where("listing_id = ? AND (status = 0 OR status = 1) AND cancelled= false", self.id).count
  end
  
  def available_ranges
    date_ranges = self.date_ranges.order("start_date ASC")
    bookings = self.bookings.where(cancelled: false).where(status: 1).order("start_date ASC")
    i,j = 0
    avail_ranges = []
    date_ranges.each do |range|
      start = range.start_date
      while i < bookings.length && bookings[i].end_date <= range.end_date
        unless start > range.end_date
          avail_ranges << [start, bookings[i].start_date]
        end
        start = bookings[i].end_date
        i += 1
      end
      avail_ranges << [start, range.end_date]
    end
    avail_ranges
    avail_ranges.reject { |range| range[0] >= range[1] }
  end
  
  def full_address
    "#{address}, #{city}, #{zip}"
  end
  
end
