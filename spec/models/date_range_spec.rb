# == Schema Information
#
# Table name: date_ranges
#
#  id         :integer          not null, primary key
#  start_date :date             not null
#  end_date   :date             not null
#  listing_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe DateRange do
  pending "add some examples to (or delete) #{__FILE__}"
end
