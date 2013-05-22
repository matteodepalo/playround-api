require 'spec_helper'

describe V1::RoundsController do
  valid_attributes = { game_name: 'dota2' }
  let(:user) { create :user }

  describe 'POST create' do
    it 'assigns the correct game to the round' do
      post_with_auth :create, { round: valid_attributes }, user: user

      assigns(:round).game.name.should eq('Dota 2')
    end
  end
end
