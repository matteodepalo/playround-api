# == Schema Information
#
# Table name: participants
#
#  id         :uuid             not null, primary key
#  team       :integer
#  round_id   :uuid
#  user_id    :uuid
#  user_type  :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_participants_on_round_id  (round_id)
#  index_participants_on_user_id   (user_id)
#

require 'spec_helper'

describe Participant do
end
