# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  fname                    :string(255)      not null
#  lname                    :string(255)      not null
#  gender                   :string(255)
#  bday                     :date
#  session_token            :string(255)
#  email                    :string(255)      not null
#  phone                    :string(255)
#  password_digest          :string(255)      not null
#  description              :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  profile_pic_file_name    :string(255)
#  profile_pic_content_type :string(255)
#  profile_pic_file_size    :integer
#  profile_pic_updated_at   :datetime
#

require 'spec_helper'

describe User do
  it { should have_one(:listing) }
  it { should have_many(:bookings) }
end
