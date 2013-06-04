class CreateUsersBuddies < ActiveRecord::Migration
  def change
    create_table :users_buddies, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :buddy_id
    end

    add_index :users_buddies, :user_id
    add_index :users_buddies, :buddy_id
  end
end
