class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :image

      t.timestamps
    end

    add_column :users, :facebook_id, :bigint
  end
end
