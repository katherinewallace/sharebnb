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
  validate :non_overlap_date_ranges 
  
  belongs_to :user
  has_many :date_ranges, inverse_of: :listing
  
  def non_overlap_date_ranges
    ranges = self.date_ranges
    if ranges
      ranges.each_with_index do |range, i|
        (i...ranges.length).each do |j|
          if range.overlaps_with?(range[j])
            errors[:base] << "Available date ranges cannot overlap"
          end
        end
      end
    end
  end

end
