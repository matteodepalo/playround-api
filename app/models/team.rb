# == Schema Information
#
# Table name: teams
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  round_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_teams_on_round_id  (round_id)
#

class Team < ActiveRecord::Base
  belongs_to :round, inverse_of: :teams
  has_many :participations, inverse_of: :team
  has_many :users, through: :participations

  validate :name, uniqueness: { scope: :round_id }
  validate :team_name_must_be_among_game_team_names
  validate :one_winning_team_per_round

  def participations=(participation_hashes)
    return unless participation_hashes

    if participation_hashes.all? { |ph| ph.is_a?(Hash) }
      users = User.find_or_create_by_hashes(participation_hashes.map { |p| p[:user] })

      users.each do |u|
        participations.build(user: u)
      end
    else
      super
    end
  end

  def display_name
    round.game.teams.select { |t| t[:name] == name }.first[:display_name]
  end

  def full?
    participations.count == round.game.teams.select { |t| t[:name] == name }.first[:number_of_players]
  end

  def win
    update(winner: true)
  end

  private

  def team_name_must_be_among_game_team_names
    errors.add(:name, "must be among:\"#{round.game.team_names.join(', ')}\"") if !round.game.team_names.include?(name)
  end

  def one_winning_team_per_round
    errors.add(:winner, 'can be true for one team per round') if winner == true && round.teams.where(winner: true).count != 0
  end
end
