require 'spec_helper'

describe 'Buddies Spec' do
  describe 'GET /index' do
    it 'responds with the list of buddies' do
      user = create :user
      3.times { user.buddies << create(:user) }
      get v1_user_buddies_path(user)

      response.status.should eq(200)
      JSON.parse(response.body)['buddies'].count.should eq(3)
    end
  end
end