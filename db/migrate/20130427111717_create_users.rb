class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :facebook_id

      t.timestamps
    end

    add_index :users, :facebook_id
  end
end
