class CreateBuddiesUsers < ActiveRecord::Migration
  def change
    create_table :buddies_users, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :buddy_id
    end

    add_index :buddies_users, :user_id
    add_index :buddies_users, :buddy_id
  end
end
