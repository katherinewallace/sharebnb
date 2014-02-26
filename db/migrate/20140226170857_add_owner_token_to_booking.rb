class AddOwnerTokenToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :owner_token, :string
  end
end
