class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds, id: :uuid do |t|
      t.string :state
      t.references :game
      t.references :arena

      t.timestamps
    end

    add_index :rounds, :game_id
  end
end
