(1..5).each do |num|
  User.create!({
    fname: "User",
    lname: "#{num}",
    email: "user#{num}@example.com",
    password: "password",
    password_confirmation: "password",
    phone: "#{num}00-123-4567"
  })
end

(1..3).each do |num|
  guestnum = rand(2..10)
  Listing.create!({
    room_type: rand(0..2),
    guests: guestnum,
    bedrooms: guestnum/2,
    bathrooms: guestnum/2,
    city: "New York",
    address: "#{num}23 Street",
    zip: "1002#{num}",
    title: "Apartment #{num}",
    price: (60 + num),
    neighborhood: "Manhattan",
    description: "A great apartment in Manhattan that accomodates #{guestnum} guests",
    user_id: num
  })
end

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