class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas, id: :uuid do |t|
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
