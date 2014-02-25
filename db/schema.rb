# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140224231101) do

  create_table "bookings", :force => true do |t|
    t.integer  "listing_id",                       :null => false
    t.integer  "guest_id",                         :null => false
    t.date     "start_date",                       :null => false
    t.date     "end_date",                         :null => false
    t.integer  "status",        :default => 0
    t.boolean  "cancelled",     :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "price"
    t.integer  "guest_num",                        :null => false
    t.integer  "date_range_id",                    :null => false
  end

  add_index "bookings", ["guest_id"], :name => "index_bookings_on_guest_id"
  add_index "bookings", ["listing_id"], :name => "index_bookings_on_listing_id"

  create_table "date_ranges", :force => true do |t|
    t.date     "start_date", :null => false
    t.date     "end_date",   :null => false
    t.integer  "listing_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "date_ranges", ["listing_id"], :name => "index_date_ranges_on_listing_id"

  create_table "listings", :force => true do |t|
    t.integer  "room_type"
    t.integer  "guests"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.string   "city"
    t.string   "neighborhood"
    t.string   "address"
    t.integer  "price"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id",      :null => false
    t.string   "zip"
    t.string   "title",        :null => false
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "listings", ["user_id"], :name => "index_listings_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "noteworthy_id"
    t.string   "noteworthy_type"
    t.string   "title"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "new",             :default => true
  end

  create_table "photos", :force => true do |t|
    t.integer  "listing_id",                              :null => false
    t.boolean  "primary"
    t.string   "caption"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "photo_file_file_name"
    t.string   "photo_file_content_type"
    t.integer  "photo_file_file_size"
    t.datetime "photo_file_updated_at"
    t.integer  "ord_num",                 :default => 50
  end

  create_table "users", :force => true do |t|
    t.string   "fname",                    :null => false
    t.string   "lname",                    :null => false
    t.string   "gender"
    t.date     "bday"
    t.string   "session_token"
    t.string   "email",                    :null => false
    t.string   "phone"
    t.string   "password_digest",          :null => false
    t.text     "description"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
