class CreateGames < ActiveRecord::Migration
  def change
    create_table :games, id: false do |t|
      t.primary_key :id, :uuid
      t.string :name

      t.timestamps
    end

    add_index :games, :name
  end
end
