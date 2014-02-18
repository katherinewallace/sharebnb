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

require 'spec_helper'

describe Listing do
  
  # subject(:listing) {Listing.new({room_type: 0, guests: 1, bedrooms: 1, bathrooms: 1, 
  #       city: "New York", neighborhood: "LIC", address: "1233", price: 67, zip: "11234", user_id: 1, title: "listing1"})}
  # 
  # let(:range3) { listing.dates_ranges.new({start_date: Time.2.months.ago, end_date: Time.1.month.ago})}
        
  it { should belong_to(:user) }
  it { should have_many(:bookings) }
  it { should have_many(:photos) }
  it { should have_many(:reviews) }
  it { should have_many(:available_ranges)}
  
  # it "should be valid" do
  #   expect(listing).to be_valid
  # end
  # 
  # describe "date ranges" do
  #   
  #   before do
  #     let(:range1) { listing.date_ranges.new({start_date: Time.10.days.ago, end_date: Time.now}) }
  #     let(:range2) { listing.date_ranges.new({start_date: Time.14.days.ago, end_date: Time.10.days.ago})}
  #   end
  # 
  #   it "should not allow overlapping date ranges" do
  #     before do
  #     
  #     end
  #   end
  # end
end 
