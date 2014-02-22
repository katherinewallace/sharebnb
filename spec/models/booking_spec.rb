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
#

require 'spec_helper'

describe Booking do
  subject(:book1)
  
  it { should belong_to(:guest) }
  it { should belong_to(:listing) }
  
  it "should calculate subtotal based on the price of the listing and the number of days" do
    
  end
  it "should not allow an invalid date range"
  
  describe "availability" do
    it "should not overlap with any approved bookings"
    it "should be within a date range for its listing"
  end
end
