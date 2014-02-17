class ChangeTypeOfZipCode < ActiveRecord::Migration
  def up
    remove_column :listings, :zip
    add_column :listings, :zip, :string
  end

  def down
    remove_column :listings, :zip
    add_column :listings, :zip, :integer
  end
end
