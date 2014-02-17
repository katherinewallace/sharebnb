class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.integer :room_type
      t.integer :guests
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :city
      t.string :neighborhood
      t.string :address
      t.string :zip
      t.integer :price
      t.text :description
      t.timestamps
    end
  end
end
