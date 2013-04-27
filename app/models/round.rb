# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  state      :string(255)
#  game_id    :integer
#  arena_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :arena

  state_machine initial: :waiting_for_players do
    event :start do
      transition from: :waiting_for_players, to: :ongoing
    end

    event :finish do
      transition from: :ongoing, to: :over
    end
  end
end
