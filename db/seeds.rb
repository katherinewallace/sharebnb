(1..100).each do |num|
  User.create!({
    fname: "User",
    lname: "#{num}",
    email: "user#{num}@example.com",
    password: "password",
    password_confirmation: "password",
    phone: "#{num}00-123-4567"
  })
end

(1..80).each do |num|
  guestnum = rand(2..9)
  listing = Listing.create!({
    room_type: rand(0..2),
    guests: guestnum,
    bedrooms: guestnum/2,
    bathrooms: guestnum/2,
    city: "New York",
    address: "#{num}23 Street",
    zip: "1002#{guestnum}",
    title: "Apartment #{num}",
    price: (60 + num),
    neighborhood: "Manhattan",
    description: "A great apartment in Manhattan that accomodates #{guestnum} guests",
    user_id: num
  })
  random_num = rand(0..30)
  listing.date_ranges.create!({ 
    start_date: Date.today + random_num.weeks,
    end_date: Date.today + random_num.weeks + 1.month
  })
end
