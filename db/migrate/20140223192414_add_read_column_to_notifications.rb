class AddReadColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :new, :boolean, default: true
  end
end
