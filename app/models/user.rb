# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  fname           :string(255)      not null
#  lname           :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  gender          :string(255)
#  bday            :date
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :email, :gender, :bday, :description
  attr_reader :password, :password_confirmation
  
end
