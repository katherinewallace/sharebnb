require 'factory_girl_rails'

describe "searching listings" do
  describe "by date" do
    it "should only return listings that are available for that date"
  end
  describe "by city and number of guests" do
    it "should only return lisitings for the correct city that can accomodate the number of guests"
  end
end

describe "making a listing" do
  it "should require a user to be signed in"
  it "should only be available to users without an existing listing"
  it "should redirect to listing edit page"
end

describe "editing a listing" do
  it "should not allow you to set an apartment as unavailable if there are existing pending or confirmed booking requests"
end