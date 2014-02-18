class CreateDateRanges < ActiveRecord::Migration
  def change
    create_table :date_ranges do |t|
      t.date :start_date, null: false
      t.date :end_date, null:false
      t.integer :listing_id, null: false
      t.timestamps
    end
    add_index :date_ranges, :listing_id
  end
end
