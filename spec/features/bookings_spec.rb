require 'spec_helper'

describe "Bookings" do
let!(:user1) { FactoryGirl.create(:user) }
let!(:user2) {FactoryGirl.create(:user)}
let!(:listing1) { FactoryGirl.create(:listing, user: user2) }
let!(:book2) { FactoryGirl.create(:booking, guest: FactoryGirl.create(:user), listing: listing1)}
let!(:book1) { FactoryGirl.create(:booking, guest: user1, listing: listing1, start_date: Date.today) }
let!(:book3) { FactoryGirl.create(:booking, guest: user1, listing: listing1, start_date: Date.today + 1.week, end_date: Date.today + 1.week + 3.days) }

describe "making a booking" do
  
  describe "when logged out" do
    before do
      visit listing_url(listing1)
    end
    
    it "should require login" do
      click_on("Book it!")
      expect(page).to have_content("Password")
    end
    
    it "should redirect back to make a booking" do
      click_on("Book it!")
      sign_in_with_email(user1.email)
      expect(page).to have_content(listing1.title)
    end
    
  end
  
  describe "when logged in" do
  
    before do
      sign_in_with_email(user1.email)
      visit listing_url(listing1)
    end
  
    it "should not go through if the apartment is not available" do
      fill_in "Check out", with: listing1.date_ranges.first.end_date + 1.day
      click_on("Book it!")
      expect(page).to have_content("not available")
    end
    
    describe "a successful booking" do
      
      before do
        fill_in "Check out", with: listing1.date_ranges.first.start_date + 1.day
        click_on("Book it!")
      end
      
      it "should generate a notification for the host" do
        old = user2.notifications.length 
        click_on("Logout")
        sign_in_with_email(user2.email)
        expect(page).to have_content("Notifications 1")
      end
      
      it "should redirect to the user trips page with booking" do
        expect(page).to have_content(listing1.title)
        expect(page).to have_content("Status: pending")
      end
      
    end 
  end
end

describe "managing bookings" do
  
  before do
    sign_in_with_email(user2.email)
    visit listing_bookings_url(listing1)
  end
  
  it "should give the option to accept or decline a booking" do
    expect(page).to have_link("Accept")
    expect(page).to have_link("Decline")
  end
  
  it "should give the option to cancel an accepted booking" do
    expect(page).to have_no_link("Cancel booking")
    first(:link, "Accept").click
    expect(page).to have_link("Cancel booking")
  end
  
  it "should tell a user if two pending bookings overlap" do
    expect(page).to have_content(user1.full_name)
    expect(page).to have_content("overlaps with")
  end
  
  it "should order bookings by date" do
    expect(page.body.index(book1.start_date.strftime("%-m/%d/%Y"))).to be < (page.body.index(book2.start_date.strftime("%-m/%d/%Y")))
    
    expect(page.body.index(book2.start_date.strftime("%-m/%d/%Y"))).to be < (page.body.index(book3.start_date.strftime("%-m/%d/%Y")))
  end
  
  it "should only be available to the owner of a listing" do
    click_on "Logout"
    sign_in_with_email(user1.email)
    visit listing_bookings_url(listing1)
    expect(page).to have_no_content("Bookings")
  end
end

describe "accepting a booking" do
  
  before do
    sign_in_with_email(user2.email)
    visit listing_bookings_url(listing1)
  end
  
  it "should move the booking from pending to confirmed list" do
    first(:link, "Accept").click
    expect(page).to have_selector("ul#confirmed-booking-list", text: book1.start_date.strftime("%-m/%d/%Y"))
    expect(page).to have_no_selector("ul#pending-booking-list", text: book1.start_date.strftime("%-m/%d/%Y"))
  
  end
  
  it "should keep the bookings in order" do
    book3.status = 1
    book3.save!
    visit listing_bookings_url(listing1)
    first(:link, "Accept").click
    expect(page.body.index(book1.start_date.strftime("%-m/%d/%Y"))).to be < (page.body.index(book3.start_date.strftime("%-m/%d/%Y")))
  end
  
  it "should decline all overlapping pending bookings" do
    expect(page).to have_content(book2.start_date.strftime("%-m/%d/%Y"))
    first(:link, "Accept").click
    expect(page).to have_no_content(book2.start_date.strftime("%-m/%d/%Y"))
  end
  
  it "should generate a notification for the guest" do
    old = user1.notifications.length 
    first(:link, "Accept").click
    click_on("Logout")
    sign_in_with_email(user1.email)
    expect(page).to have_content("Notifications #{old+1}")
  end
end

describe "declining a booking" do
  
  before do
    sign_in_with_email(user2.email)
    visit listing_bookings_url(listing1)
  end
  
  it "should remove the booking from the page" do
    expect(page).to have_content(book1.start_date.strftime("%-m/%d/%Y"))    
    first(:link, "Decline").click
    expect(page).to have_no_content(book1.start_date.strftime("%-m/%d/%Y"))
  end
  
  it "should generate a notification for the guest" do
    old = user1.notifications.length 
    first(:link, "Decline").click
    click_on("Logout")
    sign_in_with_email(user1.email)
    visit notifications_url
    expect(page).to have_content("Notifications #{old+1}")
  end
  
  it "removes overlap notifications" do
    expect(page).to have_content("overlaps")
    first(:link, "Decline").click
    expect(page).to have_no_content("overlaps")
  end
  
end

end