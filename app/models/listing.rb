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
#

class Listing < ActiveRecord::Base
  
  ROOM_TYPES = {
    0 => "entire house/apt",
    1 => "private room",
    2 => "shared room"
  }
  
  attr_accessible :room_type, :guests, :bedrooms, :bathrooms, :city, :neighborhood, 
    :address, :zip, :price, :description, :user_id, :title
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
  
  belongs_to :user
  has_many :date_ranges, inverse_of: :listing, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :photos, inverse_of: :listing, dependent: :destroy
  
  def self.filter(params)
    results = Listing
    
    if(params[:start_date].present? || params[:end_date].present?)
      results = results.joins(:date_ranges)
    end
    
    where_condition = <<-SQL
      (? BETWEEN date_ranges.start_date AND date_ranges.end_date) AND
      listings.id NOT IN (
        SELECT listing_id
        FROM bookings
        WHERE ? BETWEEN bookings.start_date AND bookings.end_date
      )
    SQL
    
    if(params[:start_date].present?)
      results = results.where(where_condition, params[:start_date], params[:start_date])
    end
    
    if(params[:end_date].present?)
      results = results.where(where_condition, params[:end_date], params[:end_date])
    end
    
    if(params[:guests].present?)
      results = results.where("guests >= ?", params[:guest_num])
    end
    
    if(params[:city].present?)
      results = results.where(city: params[:city])
    end
    
    results.all
    
  end
  
  def primary_photo_file
    primary = self.photos.where(primary: true).first
    primary ? primary.photo_file : self.photos.first.photo_file
  end
  
end
