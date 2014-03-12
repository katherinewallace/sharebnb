require 'spec_helper'

describe "Bookings" do
let(:user1) { FactoryGirl.create(:user) }
let(:user2) {FactoryGirl.create(:user)}
let(:listing1) { FactoryGirl.create(:listing, user: user2) }



describe "making a booking" do
  
  before do
    visit listing_url(listing1)
  end
  
  it "should require the user to be logged in" do
    click_button("Book it!")
    expect(page).to have_content("Password")
  end
  
  it "should show the correct subtotal" do
    fill_in "Check in", with: Date.today
    fill_in "Check out", with: Date.today + 3.days
    expect(page).to have_content("#{3*listing1.price}")
  end
  
  it "should not go through if the apartment is not available" do
    
  end
  
  it "should show a successfully created booking on the user trips page"
end

describe "managing bookings" do
  it "should only be available to the owner of a listing"
  it "should give the option to accept or decline a booking"
  it "should tell a user if two pending bookings overlap"
  it "should give the option to cancel an accepted booking"
  it "should order bookings by date"
end

describe "accepting a booking" do
  it "should move the booking from pending to confirmed list"
  it "should keep the bookings in order"
  it "should decline all overlapping pending bookings"
  it "should generate a notification for the guest"
end

describe "declining a booking" do
  it "should remove the booking from the confirmed list"
  it "should generate a notification for the guest"
  it "removes overlap notifications"
end

end