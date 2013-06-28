class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations, id: :uuid do |t|
      t.string :team
      t.uuid :round_id
      t.uuid :user_id
      t.boolean :joined, default: false

      t.timestamps
    end

    add_index :participations, :round_id
    add_index :participations, :user_id
  end
end
