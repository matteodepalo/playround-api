class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds, id: false do |t|
      t.primary_key :id, :uuid
      t.string :state
      t.references :game
      t.references :arena

      t.timestamps
    end

    add_index :rounds, :game_id
  end
end
