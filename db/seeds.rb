require 'faker'
require_relative 'seed_helper'

def generate_listing!(user_id)
  guest_num = rand(2..9)
  city = CITY_ADDRESSES.keys.sample
  address_info = CITY_ADDRESSES[city]["businesses"].sample["location"]
  
  listing = Listing.new({
    room_type: rand(0..2),
    guests: guest_num,
    bedrooms: guest_num/2,
    bathrooms: (guest_num/2 - 1),
    city: city,
    address: address_info["address"].first,
    zip: address_info["postal_code"],
    neighborhood: address_info["neighborhoods"].first,
    price: rand(30..300),
    title: "#{Faker::Company.buzzwords.sample.capitalize} Apartment",
    description: "Awesome apartment in #{address_info["neighborhoods"].first}. Accomodates #{guest_num} people",
    user_id: user_id
  })
  listing.save!
  random_num = rand(0..70)
  
  listing.date_ranges.create!({ 
    start_date: Date.today + random_num.weeks,
    end_date: Date.today + random_num.weeks + 4.month
  })
  
  3.times {listing.photos.create!({
    caption: Faker::Company.catch_phrase
  })}
  
  listing.photos.each do |photo|
    begin
      url = APT_PHOTOS.sample
      photo.picture_from_url(url)
      puts url
      photo.save!
    rescue
      puts "skipped photo #{photo.photo_file.url}"
      retry
    end
  end
  
  return listing
end

# generate users

(1..11).each do |num|
  user = User.new({
    fname: Faker::Name.first_name,
    lname: Faker::Name.last_name,
    email: "user#{num}@example.com",
    password: "password",
    password_confirmation: "password",
    phone: Faker::PhoneNumber.cell_phone
  })
  user.picture_from_url(USER_PHOTOS[num-1])
  user.save!
end

# create demo account

demo_user = User.new({
  fname: "Demo",
  lname: "User",
  email: "demo@example.com",
  password: "password",
  password_confirmation: "password",
  gender: "other",
  bday: "1989-03-17",
  phone: "222-333-4444"
})

demo_user.picture_from_url("http://i1.wp.com/www.techrepublic.com/bundles/techrepubliccore/images/icons/standard/icon-user-default.png")
demo_user.save!
generate_listing!(demo_user.id)
demo_listing = demo_user.listing
demo_user.caused_notifications.create!({user_id: demo_user.id, code: 5})

# make some pending bookings

demo_date_range = DateRange.new({start_date: Date.today, end_date: (Date.today + 6.months)})

demo_date_range.listing_id = demo_listing.id 

demo_listing.date_ranges = [demo_date_range]

(1..4).each do |num| 
  guest = User.all.sample
  booking = Booking.new({start_date: (Date.today + num.weeks), end_date: (Date.today + (2 * num).weeks), guest_num: 1})
  puts booking.start_date
  puts booking.end_date
  booking.guest_id = guest.id
  booking.listing_id = demo_listing.id
  booking.save!
end


# generate listings belonging to users
60.times do 
  user_id = rand(1..11)
  generate_listing!(user_id)
end





