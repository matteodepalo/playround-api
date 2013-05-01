# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  team       :integer
#  round_id   :uuid
#  user_id    :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participants_on_round_id  (round_id)
#  index_participants_on_user_id   (user_id)
#

class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
end
