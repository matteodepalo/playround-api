class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas, id: false do |t|
      t.primary_key :id, :uuid
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
