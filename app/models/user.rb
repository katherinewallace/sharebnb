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

class User < ActiveRecord::Base
  attr_accessible :fname, :lname, :gender, :bday, :email, :phone, :description, :password, :password_confirmation, :profile_pic, :uid
  attr_reader :password, :password_confirmation
  
  has_one :listing, dependent: :destroy
  has_many :bookings, foreign_key: :guest_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :caused_notifications, class_name: "Notification", as: :noteworthy
  
  has_attached_file :profile_pic, styles: {
        :medium => "400x400>",
        :small => "120x120#"
        }, dependent: :destroy
  
  before_validation :ensure_session_token
  
  validates :fname, presence: {message: "First name can't be blank"}
  validates :lname, presence: {message: "Last name can't be blank"}
  validates :password_digest, presence: {message: "Password can't be blank"}
  validates :password, length: {minimum: 6, message: "Password must be at least 6 characters long", allow_nil: true}
  validate :matching_passwords
  validates :email, presence: {message: "Email can't be blank"}
  validates :email, uniqueness: {message: "That email has already been taken"}
  validates_attachment_content_type :profile_pic, :content_type => %w(image/jpeg image/jpg image/png)
  
  def self.update_or_create_from_fb(auth)
    user = User.find_by_email(auth[:info][:email])
    if user
      pic = user.profile_pic.exists? ? user.profile_pic : "http://graph.facebook.com/#{auth[:uid]}/picture?type=large"
      gender = user.gender ? user.gender : auth[:extra][:raw_info][:gender]
      user.update_attributes!(
      uid: auth[:uid],
      profile_pic: pic,
      gender: gender
      )
    else
      temp_password = SecureRandom::urlsafe_base64(8)
      user = User.create!(
      uid: auth[:uid],
      fname: auth[:info][:first_name],
      lname: auth[:info][:last_name],
      password: temp_password,
      password_confirmation: temp_password,
      email: auth[:info][:email],
      profile_pic: "http://graph.facebook.com/#{auth[:uid]}/picture?type=large",
      gender: auth[:extra][:raw_info][:gender] )
    end
    user
  end
  
  def picture_from_url(url)
    self.profile_pic = url
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(email, password)
    user = find_by_email(email)
    if user.nil?
      nil
    else
      user.is_password?(password) ? user : nil
    end
  end
  
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end
  
  def full_name
    "#{self.fname} #{self.lname}"
  end
  
  def password=(password)
    @password = password
    if(@password) && !@password.empty?
      self.password_digest = BCrypt::Password.create(password)
    end
  end
  
  def password_confirmation=(password)
    @password_confirmation = password
  end
  
  def matching_passwords
    if self.password && !self.password.empty? && self.password != self.password_confirmation
      errors[:password] << "Passwords must match"
    end
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end
  
end
