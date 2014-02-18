# == Schema Information
#
# Table name: date_ranges
#
#  id         :integer          not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  listing_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DateRange < ActiveRecord::Base
  attr_accessible :start_date, :end_date
  validates :start_date, :end_date, :listing, presence: true
  
  belongs_to :listing
  
  def overlaps_with?(other_range)
    other_range.start_date.between?(self.start_date, self.end_date) ||
    other_range.end_date.between?(self.start_date, self.end_date)
  end

end
