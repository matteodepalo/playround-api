class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas, id: :uuid do |t|
      t.string :name
      t.point :lonlat, geographic: true
      t.string :foursquare_id

      t.timestamps
    end

    add_index :arenas, :foursquare_id, unique: true
  end
end
