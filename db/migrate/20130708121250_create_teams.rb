class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.boolean :winner, default: false
      t.uuid :round_id

      t.timestamps
    end

    add_index :teams, :round_id
  end
end
