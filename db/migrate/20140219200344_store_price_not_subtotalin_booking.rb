class StorePriceNotSubtotalinBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :subtotal
    add_column :bookings, :price, :integer
  end

  def down
    remove_column :bookings, :price
    add_column :bookings, :subtotal, :integer
  end
end
