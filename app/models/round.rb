# == Schema Information
#
# Table name: rounds
#
#  id         :uuid             not null, primary key
#  state      :string(255)
#  game_id    :uuid
#  arena_id   :uuid
#  user_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_rounds_on_game_id  (game_id)
#

class Round < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  belongs_to :arena
  has_many :participants
  has_many :users, through: :participants

  validates :state, presence: true
  validates :game_id, presence: true
  validate :game_cannot_be_changed_after_creation

  state_machine initial: :waiting_for_players do
    event :start do
      transition from: :waiting_for_players, to: :ongoing
    end

    event :finish do
      transition from: :ongoing, to: :over
    end
  end

  def game_name=(name)
    self.game = Game.where(name: name.to_s).first
  end

  def game_name
    game.display_name
  end

  private

  def game_cannot_be_changed_after_creation
    errors.add(:game, 'cannot be changed when updating') if persisted? && game_id_changed?
  end
end
