# == Schema Information
#
# Table name: users
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  email         :string(255)
#  facebook_id   :string(255)
#  foursquare_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_users_on_facebook_id    (facebook_id)
#  index_users_on_foursquare_id  (foursquare_id)
#

require 'spec_helper'

describe User do
  it 'is not valid without a social id' do
    build(:user, facebook_id: '', foursquare_id: '').should_not be_valid
  end

  it 'adds buddies via the buddy_list setter' do
    pending
  end

  it 'authenticates with an api_key' do
    pending
  end

  describe '#self.find_or_create_by_hashes' do
    it 'creates or finds a list of users from an array of hashes' do
      user = create :user

      User.find_or_create_by_hashes([
        { user: { id: user.id } },
        { user: { facebook_id: MATTEO_DEPALO['id'] } },
        { user: { facebook_id: EUGENIO_DEPALO['id'] } }
      ])

      users = User.all.to_a
      users.first.id.should eq(user.id)
      users[1..2].map(&:facebook_id).should eq([MATTEO_DEPALO['id'], EUGENIO_DEPALO['id']])
      users[1..2].map(&:name).should eq(['Matteo Depalo', 'Eugenio Depalo'])
    end
  end
end
