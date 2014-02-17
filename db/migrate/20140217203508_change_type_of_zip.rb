class ChangeTypeOfZip < ActiveRecord::Migration
  def change
    remove_column :listings, :zip
    add_column :listings, :zip, :integer
    add_column :listings, :user_id, :integer, null: false
    add_index :listings, :user_id
  end
end
