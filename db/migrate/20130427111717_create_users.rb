class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :image
      t.string :facebook_id
      t.string :foursquare_id


      t.timestamps
    end

    add_index :users, :facebook_id
    add_index :users, :foursquare_id
  end
end
