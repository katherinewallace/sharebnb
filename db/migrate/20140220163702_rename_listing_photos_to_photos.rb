class RenameListingPhotosToPhotos < ActiveRecord::Migration
 
  def change
    rename_table :listing_photos, :photos
  end
end
