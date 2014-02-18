# == Schema Information
#
# Table name: listings
#
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
#

require 'spec_helper'

describe Listing do
  it { should belong_to(:user) }
  it { should have_many(:bookings) }
  it { should have_many(:photos) }
  it { should have_many(:reviews) }
  it { should have_many(:available_ranges)}
end 
