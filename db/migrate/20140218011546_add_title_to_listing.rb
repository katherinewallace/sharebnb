class AddTitleToListing < ActiveRecord::Migration
  def change
    add_column :listings, :title, :string, null: false
  end
end
