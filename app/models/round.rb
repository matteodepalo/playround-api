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
  has_many :participations
  has_many :users, through: :participations

  validates :state, presence: true
  validates :game_id, presence: true
  validates :user_id, presence: true
  validates :arena_id, presence: true
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

  def arena_properties=(options = {})
    self.arena = Arena.where(options).first_or_create
  end

  def participation_list=(participation_hashes)
    users = User.find_or_create_by_hashes(participation_hashes.map { |h| h[:user] })

    users.each do |u|
      participation = participation_hashes.select { |p| p[:user][:id] == u.id || p[:user][:facebook_id] == u.facebook_id }.first
      self.participations << Participation.new(team: participation[:team], user: u, round: self)
    end
  end

  def available_teams
    # participations relation cannot be used because creating a participation doesn't update the round model association
    # this is because inverse_of doesn't work for inverse has_many relationships
    # (in this case it would work for participation.round, but not for round.participations)
    # as stated in http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
    game.teams - Participation.where(round: self).map(&:team)
  end

  private

  def check_game_name_validity
    errors.add(:base, "game_name must be among: \"#{Game::VALID_GAME_NAMES.join(', ')}\"") if game_name_validity == false
  end

  def game_cannot_be_changed_after_creation
    errors.add(:game, 'cannot be changed after creation') if persisted? && game_id_changed?
  end
end
