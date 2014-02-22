# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  noteworthy_id   :integer
#  noteworthy_type :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Notifications < ActiveRecord::Base
  attr_accessible :user_id, :noteworthy_id, :noteworthy_type, :title
  
  belongs_to :noteworthy, polymorphic: true
end
