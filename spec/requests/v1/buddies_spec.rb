require 'spec_helper'

describe 'Buddies Spec' do
  describe 'GET users/1/buddies' do
    it 'responds with the list of buddies' do
      user = create :user
      3.times { user.buddies << create(:user) }
      get v1_user_buddies_path(user)

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end
  end

  describe 'GET users/me/buddies' do
    it 'responds with the list of current_user\'s buddies' do
      user = create :user
      3.times { user.buddies << create(:user) }
      get_with_auth v1_user_buddies_path(user_id: 'me'), user: user

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        user = create :user
        3.times { user.buddies << create(:user) }
        get v1_user_buddies_path(user_id: 'me')

        response.status.should eq(401)
      end
    end
  end

  valid_attributes =  [{ facebook_id: MATTEO_DEPALO['id'] }, { facebook_id: EUGENIO_DEPALO['id'] }]

  describe 'POST users/1/buddies' do
    describe 'with authentication and authentication' do
      it 'adds users to the list of buddies', :vcr do
        user = create :user
        post_with_auth v1_user_buddies_path(user), { buddies: valid_attributes }, user: user

        response.status.should eq(200)
        buddies = JSON.parse(response.body)['buddies']
        buddies.count.should eq(2)
        buddies.first['name'].should eq('Matteo Depalo')
        buddies.first['facebook_id'].should eq(MATTEO_DEPALO['id'])
        buddies.last['name'].should eq('Eugenio Depalo')
        buddies.last['facebook_id'].should eq(EUGENIO_DEPALO['id'])
      end
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        user = create :user
        post v1_user_buddies_path(user), { buddies: valid_attributes }

        response.status.should eq(401)
      end
    end

    describe 'without authorization' do
      it 'responds with forbidden' do
        user = create :user
        post_with_auth v1_user_buddies_path(user), { buddies: valid_attributes }, user: create(:user)

        response.status.should eq(403)
      end
    end
  end

  describe 'POST users/me/buddies' do
    it 'adds users to the list of current_user\'s buddies', :vcr do
      user = create :user
      post_with_auth v1_user_buddies_path(user_id: 'me'), { buddies: valid_attributes }, user: user

      response.status.should eq(200)
      buddies = JSON.parse(response.body)['buddies']
      buddies.count.should eq(2)
      buddies.first['name'].should eq('Matteo Depalo')
      buddies.first['facebook_id'].should eq(MATTEO_DEPALO['id'])
      buddies.last['name'].should eq('Eugenio Depalo')
      buddies.last['facebook_id'].should eq(EUGENIO_DEPALO['id'])
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        user = create :user
        post v1_user_buddies_path(user_id: 'me'), { buddies: valid_attributes }

        response.status.should eq(401)
      end
    end
  end
end