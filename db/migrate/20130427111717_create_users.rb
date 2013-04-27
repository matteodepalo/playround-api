class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.primary_key :id, :uuid
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
