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

require 'spec_helper'

describe Listing do
  
  let!(:listing1) { FactoryGirl.create(:listing) }
        
  it { should belong_to(:user) }
  it { should have_many(:bookings) }
  it { should have_many(:photos) }
  it { should have_many(:date_ranges)}
  
  it "should not allow you to set an apartment as unavailable if there are existing pending or confirmed booking requests" do
    range = listing1.date_ranges.first
    make_booking(1, listing1, range.start_date, range.start_date + 3.days)
    range.start_date = range.end_date
    range.end_date = range.start_date + 1.month
    expect(range).to be_invalid
  end
  
end 
