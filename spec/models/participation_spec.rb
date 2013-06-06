# == Schema Information
#
# Table name: participations
#
#  id         :uuid             not null, primary key
#  team       :integer
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

require 'spec_helper'

describe Participation do
  let(:user) { create :user }
  let(:round) { create :round }

  it 'must have a unique combination of round and user' do
    Participation.create(round: round, user: user)
    participation = Participation.new(round: round, user: user)

    participation.should be_invalid
    participation.errors.full_messages.should include('user_id and round_id must be unique')
  end

  describe '#self.create_or_update' do
    it 'creates a participation' do
      participation = create :participation, round: round, user: user

      round.participations.should include(participation)
    end

    it 'updates a participation if it already exists' do
      participation = create :participation, round: round, user: user
      updated_participation = Participation.create_or_update(round: round, user: user, joined: true)

      participation.joined.should eq(false)
      participation.id.should eq(updated_participation.id)
      updated_participation.joined.should eq(true)
    end
  end
end
