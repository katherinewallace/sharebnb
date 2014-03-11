# == Schema Information
#
# Table name: bookings
#
#  id            :integer          not null, primary key
#  listing_id    :integer          not null
#  guest_id      :integer          not null
#  start_date    :date             not null
#  end_date      :date             not null
#  status        :integer          default(0)
#  cancelled     :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  price         :integer
#  guest_num     :integer          not null
#  date_range_id :integer          not null
#  owner_token   :string(255)
#

FactoryGirl.define do
  factory :booking do
  end
end
