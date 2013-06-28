class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds, id: :uuid do |t|
      t.string :state
      t.uuid :game_id
      t.uuid :arena_id
      t.uuid :user_id

      t.timestamps
    end

    add_index :rounds, :game_id
    add_index :rounds, :arena_id
    add_index :rounds, :user_id
  end
end
