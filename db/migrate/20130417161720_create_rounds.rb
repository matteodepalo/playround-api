class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :status

      t.timestamps
    end
  end
end
