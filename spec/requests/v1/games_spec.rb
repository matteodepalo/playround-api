require 'spec_helper'

describe 'Games Requests' do
  describe 'GET /games/1' do
    it 'returns the requested game' do
      game = create :game
      get v1_game_path(game)

      response.status.should eq(200)
      response.body.should include(game.id.to_s)
      response.body.should include(game.name)
    end
  end

  describe 'GET /games' do
    it 'returns the list of games' do
      game = create :game
      get v1_games_path

      response.status.should eq(200)
    end
  end
end