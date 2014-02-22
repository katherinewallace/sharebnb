class AddDateRangeToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :date_range_id, :integer, null: false
  end
end
