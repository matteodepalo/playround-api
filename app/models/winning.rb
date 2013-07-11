class Winning
  include ActiveModel::Model
  include ActiveModel::Validations

  validates :round, presence: true
  validate :round_must_be_ongoing
  validate :team_name_must_be_among_valid_ones

  attr_reader :round, :team_name

  def initialize(round: nil, team_name: nil)
    @round = round
    @team_name = team_name
  end

  def save
    if valid?
      round.declare_winner(team_name)
      true
    else
      false
    end
  end

  private

  def round_must_be_ongoing
    errors.add(:round, 'must be ongoing') unless round.ongoing?
  end

  def team_name_must_be_among_valid_ones
    errors.add(:team_name, "must be among: #{round.game.team_names.join(', ')}") unless round.game.team_names.include?(team_name)
  end
end