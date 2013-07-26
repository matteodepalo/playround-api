class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas, id: :uuid do |t|
      t.string :name
      t.point :location, srid: 3785
      t.string :foursquare_id

      t.timestamps
    end

    add_index :arenas, :foursquare_id, unique: true
    add_index :arenas, :location, spatial: true
  end
end
