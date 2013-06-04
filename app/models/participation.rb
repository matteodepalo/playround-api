# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team       :integer
#  round_id   :uuid
#  user_id    :uuid
#  joined     :boolean          default(FALSE)
#  user_type  :string(255)
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

  default_scope -> { includes(:user) }

  validate :round_and_user_must_be_unique

  def self.create_or_update(options = {})
    if participation = where(round: options[:round], user: options[:user]).first
      participation.update(joined: true)
      participation
    else
      create(options)
    end
  end

  private

  def round_and_user_must_be_unique
    if persisted?
      errors.add(:base, 'user_id and round_id must be unique') unless round.participations.where(user_id: user_id).count == 1
    else
      errors.add(:base, 'user_id and round_id must be unique') unless round.participations.where(user_id: user_id).first.nil?
    end
  end
end
