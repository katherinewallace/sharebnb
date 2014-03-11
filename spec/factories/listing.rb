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
#  latitude     :float
#  longitude    :float

FactoryGirl.define do
  guest_num = rand(2..9)
  factory :listing do
    room_type {rand(0..2)}
    guests {guest_num}
    bedrooms {guest_num/2}
    bathrooms {(guest_num/2 - 1)}
    city {["New York","Philadelphia"].sample}
    address {Faker::Address.street_address}
    zip {Faker::Address.zip_code}
    neighborhood {Faker::Lorem.word}
    price {rand(30..300)}
    title "#{Faker::Lorem.word.capitalize} Apartment"
    description "Awesome apartment. Accomodates #{guest_num} people"    
  end
end