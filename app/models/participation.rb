# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team_id    :uuid
#  user_id    :uuid
#  joined     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_team_id  (team_id)
#  index_participations_on_user_id  (user_id)
#

class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :team, inverse_of: :participations

  validates :team, presence: true
  validate :team_and_user_must_be_unique
  validate :team_must_not_be_full
  validate :round_must_be_waiting_for_players

  after_create :start_round, if: -> { round.participations.count == round.game.number_of_players }

  def round
    team.round
  end

  private

  def team_and_user_must_be_unique
    user_round_participations = round.participations.where(user_id: user_id)

    condition = if persisted?
      user_round_participations.count == 1
    else
      user_round_participations.first.nil?
    end

    errors.add(:base, 'user and round must be unique') unless condition
  end

  def start_round
    round.start
  end

  def team_must_not_be_full
    errors.add(:base, 'team is full') if team.full?
  end

  def round_must_be_waiting_for_players
    errors.add(:round, 'must be waiting for players') unless round.waiting_for_players?
  end
end
