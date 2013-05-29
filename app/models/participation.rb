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
  belongs_to :user, polymorphic: true
  belongs_to :round
end