# == Schema Information
#
# Table name: listing_photos
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  primary    :boolean
#  caption    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ActiveRecord::Base
  attr_accessible :primary, :caption, :photo_file
  
  has_attached_file :photo_file, styles: {
        :large => "1600x1600>",
        :small => "80x80#",
        medium: "500x300#" 
      }, dependent: :destroy 
      
  belongs_to :listing, inverse_of: :photos
  
  def picture_from_url(url)
      self.photo_file = url
  end
end
