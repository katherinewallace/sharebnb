class CreateListingPhotos < ActiveRecord::Migration
  def change
    create_table :listing_photos do |t|
      t.integer :listing_id, null: false
      t.boolean :primary
      t.string :caption
      t.timestamps
    end
  end
end
