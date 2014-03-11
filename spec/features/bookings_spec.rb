describe "making a booking" do
  it "should require the user to be logged in"
  it "should show the correct subtotal"
  it "should not go through if the apartment is not available"
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