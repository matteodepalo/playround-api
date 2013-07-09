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
#  index_rounds_on_arena_id  (arena_id)
#  index_rounds_on_game_id   (game_id)
#  index_rounds_on_user_id   (user_id)
#

class Round < ActiveRecord::Base
  attr_accessor :game_name_validity

  belongs_to :user
  belongs_to :game
  belongs_to :arena
  has_many :teams, inverse_of: :round
  has_many :participations, through: :teams
  has_many :users, through: :participations

  validates :state, presence: true
  validates :game, presence: true
  validates :user, presence: true
  validates :arena, presence: true
  validate :game_cannot_be_changed_after_creation
  validate :check_game_name_validity

  state_machine initial: :waiting_for_players do
    event :start do
      transition from: :waiting_for_players, to: :ongoing
    end

    event :finish do
      transition from: :ongoing, to: :over
    end
  end

  def game_name=(name)
    name = name.to_s

    begin
      self.game = Game.where(name: name).first || Game.build_and_create(name: name)
      @game_name_validity = true
    rescue Game::InvalidGameNameError
      @game_name_validity = false
    end
  end

  def game_name
    game.display_name
  end

  def arena=(arena)
    if arena.is_a?(Hash)
      super(Arena.where(arena).first_or_create)
    else
      super
    end
  end

  def teams=(team_hashes)
    team_hashes.each do |th|
      team = find_or_initialize_team(th[:name])
      team.users = th[:users]
    end
  end

  def find_or_initialize_team(team_name)
    teams.where(name: team_name).first || teams.build(name: team_name)
  end

  private

  def check_game_name_validity
    errors.add(:base, "game_name must be among: #{Game::VALID_GAME_NAMES.join(', ')}") if game_name_validity == false
  end

  def game_cannot_be_changed_after_creation
    errors.add(:game, 'cannot be changed after creation') if persisted? && game_id_changed?
  end
end
