class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname, null: false
      t.string :lname, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :gender
      t.date :bday
      t.text :description
      
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
