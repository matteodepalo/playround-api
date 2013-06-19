# == Schema Information
#
# Table name: users
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  email       :string(255)
#  facebook_id :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_users_on_facebook_id  (facebook_id)
#

require 'spec_helper'

describe User do
  it 'is not valid without a social id' do
    build(:user, facebook_id: '').should_not be_valid
  end

  it 'adds buddies via the buddy_list setter' do
    user = create :user
    buddy = create :user

    user.buddy_list = [
      { id: buddy.id },
      { facebook_id: MATTEO_DEPALO['id'] },
      { facebook_id: EUGENIO_DEPALO['id'] }
    ]

    users = user.buddies
    users.count.should eq(3)
    users.map(&:id).should include(buddy.id)
    facebook_users = users.select { |u| u.id != buddy.id }
    facebook_users.map(&:facebook_id).should eq([MATTEO_DEPALO['id'], EUGENIO_DEPALO['id']])
    facebook_users.map(&:name).should eq(['Matteo Depalo', 'Eugenio Depalo'])
  end

  it 'authenticates with an api_key' do
    user = create :user
    api_key = create :api_key, user: user

    User.authenticate(api_key.access_token).should eq(user)
  end

  describe '#self.find_or_create_by_hashes' do
    it 'creates or finds a list of users from an array of hashes' do
      user = create :user

      User.find_or_create_by_hashes([
        { id: user.id },
        { facebook_id: MATTEO_DEPALO['id'] },
        { facebook_id: EUGENIO_DEPALO['id'] }
      ])

      users = User.all.to_a
      users.count.should eq(3)
      users.first.id.should eq(user.id)
      users[1..2].map(&:facebook_id).should eq([MATTEO_DEPALO['id'], EUGENIO_DEPALO['id']])
      users[1..2].map(&:name).should eq(['Matteo Depalo', 'Eugenio Depalo'])
    end
  end

  describe '#self.find_or_create_by_facebook_oauth' do
    it 'updates infos about a facebook user already in the database' do
      User.find_or_create_by_facebook_oauth(MATTEO_DEPALO.except('email'))
      user = User.first
      user.name.should eq('Matteo Depalo')
      user.email.should be_nil

      User.find_or_create_by_facebook_oauth(MATTEO_DEPALO.merge('first_name' => 'Ciccio'))
      user = user.reload
      user.name.should eq('Ciccio Depalo')
      user.email.should_not be_nil
    end
  end
end
