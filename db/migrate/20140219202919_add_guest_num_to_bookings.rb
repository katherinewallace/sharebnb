class AddGuestNumToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :guest_num, :integer, null: false
  end
end
