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
  has_many :users, through: :participants, source: :user, source_type: 'User'
  has_many :unregistered_users, through: :participants, source: :user, source_type: 'UnregisteredUser'

  validates :state, presence: true
  validates :game_id, presence: true
  validates :user_id, presence: true
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

  def participant_list=(participant_hashes)
    participant_hashes.each do |participant|
      if participant[:id]
        self.participants << Participant.new(user: User.where(id: participant[:id]).first, round: self)
      else
        self.participants << Participant.new(user: UnregisteredUser.where(participant).first_or_create, round: self)
      end
    end
  end

  def participant_list
    users + unregistered_users
  end

  private

  def game_cannot_be_changed_after_creation
    errors.add(:game, 'cannot be changed after creation') if persisted? && game_id_changed?
  end
end
