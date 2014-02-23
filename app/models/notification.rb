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

class Notification < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  attr_accessible :user_id, :noteworthy_id, :noteworthy_type, :title
  
  belongs_to :noteworthy, polymorphic: true
  belongs_to :user
  
  validates :user_id, :noteworthy_id, :noteworthy_type, :title, presence: true
  
  def self.unread(user_id)
    Notification.where("user_id = ? AND new = true", user_id).count(:id)
  end
  
end
