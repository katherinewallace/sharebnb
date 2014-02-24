class AddOrderToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :ord_num, :integer, default: 50
  end
end
