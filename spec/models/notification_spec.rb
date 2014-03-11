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

require 'spec_helper'

describe Notification do
  pending "add some examples to (or delete) #{__FILE__}"
end
