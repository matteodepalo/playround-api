class CreateGames < ActiveRecord::Migration
  def change
    create_table :games, id: :uuid do |t|
      t.string :name

      t.timestamps
    end

    add_index :games, :name
  end
end
