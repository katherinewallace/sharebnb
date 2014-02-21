class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :noteworthy_id
      t.string :noteworthy_type
      t.string :title
      t.timestamps
    end
  end
end
