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
  validate :valid_range
  validate :no_overlap
  validate :preserve_bookings, on: :update
  
  belongs_to :listing
  
  def overlaps_with?(other_range)
    other_range.start_date.between?(self.start_date, self.end_date) ||
    other_range.end_date.between?(self.start_date, self.end_date)
  end
  
  def contains?(other_range)
    other_range.start_date.between?(self.start_date, self.end_date) && 
    other_range.end_date.between?(self.start_date, self.end_date)
  end
  
  def valid_range
    unless self.end_date > self.start_date
      errors[:base] << "Invalid date range"
    end
  end
  
  def no_overlap
    others = DateRange.where("listing_id = ? AND id != ?", self.listing_id, self.id)
    others.each do |other|
      if(overlaps_with?(other))
        errors[:base] << "Date ranges cannot overlap"
        return
      end
    end
  end
  
  def preserve_bookings
    if self.changed?
      where_condition = <<-SQL
      bookings.date_range_id = ? AND
      bookings.cancelled = false AND
      bookings.status != 2 AND 
      (bookings.start_date < ? OR bookings.end_date > ?)
      SQL
      bookings = Booking.where(where_condition, self.id, self.start_date, self.end_date).count(:id)
      if bookings > 0
        errors[:base] << "Please cancel or decline the existing confirmed/pending bookings that fall outside of these dates before updating"
      end
    end
  end

end
