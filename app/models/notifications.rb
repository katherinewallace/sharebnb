class Notifications < ActiveRecord::Base
  attr_accessible :user_id, :noteworthy_id, :noteworthy_type, :title
  
  belongs_to :noteworthy, polymorphic: true
end
