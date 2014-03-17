require 'factory_girl_rails'

describe "Listings" do
  
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:listing1) { FactoryGirl.create(:listing, user: user2) }
  let!(:listing2) { FactoryGirl.create(:listing, user: FactoryGirl.create(:user)) }
  let!(:range1) { FactoryGirl.create(:date_range, start_date: Date.today + 2.weeks, end_date: Date.today + 1.month, listing: listing1) }
  let!(:range2) { FactoryGirl.create(:date_range, start_date: Date.today + 3.weeks, end_date: Date.today + 1.month, listing: listing2) }
  let!(:listing3) { FactoryGirl.create(:listing, user: FactoryGirl.create(:user)) }
  let!(:listing4) { FactoryGirl.create(:listing, user: FactoryGirl.create(:user)) }
  let(:listings) { [listing1, listing2, listing3, listing4] }

  describe "searching listings" do
    
    describe "by date" do
      before do
        listing1.date_ranges = [range1]
        listing2.date_ranges = [range2]
        listing1.save!
        listing2.save!
        visit root_url
        fill_in "Check in", with: (Date.today)
        fill_in "Check out", with: (Date.today + 4.days)
        click_on "Search"
      end
      
      it "should only return listings that are available for that date" do
        expect(page).to have_content(listing3.title)
        expect(page).to have_content(listing4.title)
        expect(page).to have_no_content(listing1.title)
        expect(page).to have_no_content(listing2.title)
      end
    end
    
    describe "by city and number of guests" do
      
      before do
        visit root_url
      end
      
      it "should only return lisitings for the correct city" do
        
        select("New York", from: "City")
        click_on "Search"
        listings.each do |listing|
          if listing.city == "New York"
            expect(page).to have_content(listing.title)
          else
            expect(page).to have_no_content(listing.title)
          end
        end
        
      end
      
      it "should only return listings that can accomodate the number of guests" do
        fill_in "Guests", with: "4"
        click_on "Search"
        listings.each do |listing|
          if listing.guests >= 4
            expect(page).to have_content(listing.title)
          else
            expect(page).to have_no_content(listing.title)
          end
        end
      end
    end
  end

  describe "making a listing" do
    
    before do
      visit root_url
    end
    
    it "should require a user to be signed in" do
      click_on "List Your Space"
      expect(page).to have_content("Password")
    end
    
    it "should only be available to users without an existing listing" do
      sign_in_with_email(user2.email)
      expect(page).to have_no_link("List Your Space")
    end
    
    it "should redirect to listing edit page" do
      sign_in_with_email(user1.email)
      click_on "List Your Space"
      fill_in "Title", with: "My apartment"
      fill_in "Price", with: "400"
      choose "private room"
      fill_in "Neighborhood", with: "Jackson Heights"
      fill_in "Street Address", with: "3410 75th Street"
      fill_in "Zip Code", with: "11372"
      click_on "Submit"
      expect(page).to have_content("Edit Your Listing")
    end
  end
  
end