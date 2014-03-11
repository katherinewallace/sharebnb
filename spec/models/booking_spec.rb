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
#  owner_token   :string(255)
#

require 'spec_helper'

describe Booking do
  subject(:book1) { Booking.new(start_date: Date.today, end_date: Date.today + 1.week, guest_num: 1) }
  let(:book2) { Booking.new(start_date: Date.today + 3.days, end_date: Date.today + 2.weeks)}
  let(:list1) {build(:listing)}  
  it { should belong_to(:guest) }
  it { should belong_to(:listing) }
  
  before do
    book1.listing = list1
    book2.status = 1
  end
  
  it "should calculate subtotal based on the price of the listing and the number of days" do
   
    expect(book1.subtotal).to be(list1.price*7)
  end
  it "should not allow an invalid date range" do
    book1.end_date = 1.week.ago
    expect(book1).to be_invalid
  end
  
  describe "availability" do
    it "should not overlap with any approved bookings" do 
      list1.bookings = [book1, book2]
      expect(book1).to be_invalid
    end
                                                                                              end
end
