require 'spec_helper'

describe 'Buddyships Requests' do
  valid_attributes =  [{ facebook_id: MATTEO_DEPALO['id'] }, { facebook_id: EUGENIO_DEPALO['id'] }]

  describe 'POST users/me/buddyships' do
    it 'adds users to the list of current_user\'s buddies', :vcr do
      user = create :user
      post_with_auth v1_user_buddyships_path(user_id: 'me'), { buddyships: valid_attributes }, user: user

      response.status.should eq(201)
      buddyships = JSON.parse(response.body)['buddyships']
      buddyships.count.should eq(2)
      buddyships.first['user']['name'].should eq(user.name)
      buddyships.first['buddy']['name'].should eq('Matteo Depalo')
      buddyships.first['buddy']['facebook_id'].should eq(MATTEO_DEPALO['id'])
      buddyships.last['buddy']['name'].should eq('Eugenio Depalo')
      buddyships.last['buddy']['facebook_id'].should eq(EUGENIO_DEPALO['id'])
    end

    describe 'without authentication' do
      it 'responds with unauthorized' do
        user = create :user
        post v1_user_buddyships_path(user_id: 'me'), { buddies: valid_attributes }

        response.status.should eq(401)
      end
    end
  end
end