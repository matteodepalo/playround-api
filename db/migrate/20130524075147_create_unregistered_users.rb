class CreateUnregisteredUsers < ActiveRecord::Migration
  def change
    create_table :unregistered_users, id: :uuid do |t|
      t.string :facebook_id
      t.string :foursquare_id
      t.string :name

      t.timestamps
    end

    add_index :unregistered_users, :facebook_id
    add_index :unregistered_users, :foursquare_id
  end
end
