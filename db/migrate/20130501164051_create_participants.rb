class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants, id: :uuid do |t|
      t.integer :team
      t.uuid :round_id
      t.uuid :user_id
      t.boolean :joined, default: false
      t.string :user_type

      t.timestamps
    end

    add_index :participants, :round_id
    add_index :participants, :user_id
  end
end
