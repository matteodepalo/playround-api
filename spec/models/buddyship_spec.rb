# == Schema Information
#
# Table name: buddyships
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  buddy_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_buddyships_on_buddy_id  (buddy_id)
#  index_buddyships_on_user_id   (user_id)
#

require 'spec_helper'

describe Buddyship do
  it 'has different user_id and buddy_id' do
    user = create :user

    buddyship = Buddyship.new(user: user, buddy: user)
    buddyship.should be_invalid
    buddyship.errors[:base].first.should eq('user_id and buddy_id must be different')
  end
end
