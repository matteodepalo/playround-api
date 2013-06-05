class CreateBuddyships < ActiveRecord::Migration
  def change
    create_table :buddyships, id: :uuid do |t|
      t.uuid :user_id
      t.uuid :buddy_id

      t.timestamps
    end

    add_index :buddyships, :user_id
    add_index :buddyships, :buddy_id
  end
end
