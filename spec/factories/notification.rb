# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  noteworthy_id   :integer
#  noteworthy_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  new             :boolean          default(TRUE)
#  code            :integer          not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
  end
end
