require 'spec_helper'

describe 'Games Requests' do
  describe 'GET /games' do
    it 'returns the list of games' do
      Game::VALID_GAME_NAMES.each do |game_name|
        Game.build_and_create(name: game_name)
      end

      get v1_games_path

      response.status.should eq(200)
      JSON.parse(response.body)['games'].count.should eq(Game::VALID_GAME_NAMES.count)
    end
  end
end