# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team       :string(255)
#  round_id   :uuid
#  user_id    :uuid
#  joined     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participations_on_round_id  (round_id)
#  index_participations_on_user_id   (user_id)
#

class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :round

  validates :team, presence: true

  default_scope -> { includes(:user) }

  validate :round_and_user_must_be_unique
  validate :team_name_must_be_among_the_available_ones

  before_validation :auto_assign_team, unless: -> { team.present? }, on: :create

  def self.create_or_update(options = {})
    if participation = where(round: options[:round], user: options[:user]).first
      participation.update(joined: true)
      participation
    else
      create(options)
    end
  end

  private

  def auto_assign_team
    self.team = round.available_teams.first
  end

  def team_name_must_be_among_the_available_ones
    errors.add(:team, "must be among:\"#{round.available_teams.join(', ')}\"") if team_changed? && !round.available_teams.include?(team)
  end

  def round_and_user_must_be_unique
    add_error = -> {
      errors.add(:base, 'user_id and round_id must be unique')
    }

    user_round_participations = round.participations.where(user_id: user_id)

    if persisted?
      add_error.call unless user_round_participations.count == 1
    else
      add_error.call unless user_round_participations.first.nil?
    end
  end
end
