FactoryGirl.define do
  factory :user do
    fname { Faker::Name.first_name }
    lname { Faker::Name.last_name }
    email { Faker::Internet.safe_email }
    password "password"
    password_confirmation "password"
    
  end
end