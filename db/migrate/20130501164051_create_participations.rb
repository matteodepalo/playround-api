class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations, id: :uuid do |t|
      t.uuid :team_id
      t.uuid :user_id

      t.timestamps
    end

    add_index :participations, :team_id
    add_index :participations, :user_id
  end
end
