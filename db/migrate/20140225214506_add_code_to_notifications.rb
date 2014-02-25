class AddCodeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :code, :integer, null: false
    remove_column :notifications, :title
  end
end
