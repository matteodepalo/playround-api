class Team < ActiveRecord::Base
  belongs_to :round, inverse_of: :teams
  has_many :participations, inverse_of: :team
  has_many :users, through: :participations

  validate :name, uniqueness: { scope: :round_id }
  validate :team_name_must_be_among_game_team_names

  def users=(user_hashes)
    if user_hashes.all? { |uh| uh.is_a?(Hash) }
      users = User.find_or_create_by_hashes(user_hashes)

      users.each do |u|
        participations.build(user: u)
      end
    else
      super
    end
  end

  def full?
    participations.count == round.game.teams.select { |team| team[:name] == name }.first[:number_of_players]
  end

  private

  def team_name_must_be_among_game_team_names
    errors.add(:name, "must be among:\"#{round.game.team_names.join(', ')}\"") if !round.game.team_names.include?(name)
  end
end
