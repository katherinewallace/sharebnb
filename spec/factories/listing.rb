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
  factory :listing do
    room_type { rand(0..2) }
    guests { rand(1..9) }
    bedrooms { rand(1..4) }
    bathrooms { rand(1..4) }
    city {["New York","Philadelphia"].sample}
    address { Faker::Address.street_address }
    zip { Faker::Address.zip_code }
    neighborhood { Faker::Lorem.word }
    price { rand(30..300) }
    title { "#{Faker::Lorem.word.capitalize} Apartment" }
    description "Awesome apartment. Stay here!"
    
    association :user, factory: :user
    
    after(:create) do |listing|
        listing.date_ranges << create(:date_range, listing_id: listing.id)
      end
    end

end