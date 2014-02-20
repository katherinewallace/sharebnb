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

require 'spec_helper'

describe ListingPhoto do
  pending "add some examples to (or delete) #{__FILE__}"
end
