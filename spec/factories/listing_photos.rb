# == Schema Information
#
# Table name: listing_photos
#
#  id         :integer          not null, primary key
#  listing_id :integer          not null
#  primary    :boolean
#  caption    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing_photo do
  end
end
