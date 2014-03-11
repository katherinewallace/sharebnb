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

require 'spec_helper'

describe DateRange do
  subject(:range1) { DateRange.new(start_date: Date.today, end_date: Date.today + 1.week)}
  let(:range2) { DateRange.new(start_date: Date.today + 3.days, end_date: Date.today + 2.weeks)}
  
  it "should not overlap with another date range for the same listing" do
    range1.listing_id = 1
    range2.listing_id = 1
    expect(range1).to be_invalid
  end
  it "should be a valid range" do
    range1.start_date = Date.today + 2.weeks
    expect(range1).to be_invalid
  end
end
