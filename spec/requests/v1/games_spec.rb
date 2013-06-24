require 'spec_helper'

describe 'Games Requests' do
  describe 'GET /games/1' do
    it 'returns the requested game' do
      game_factory = Game.build_and_create(name: :dota2)
      get v1_game_path(game_factory)

      response.status.should eq(200)
      game = JSON.parse(response.body)['game']
      game['id'].should eq(game_factory.id.to_s)
      game['display_name'].should eq('Dota 2')
      game['teams'].should eq([{ 'name' => 'radiant', 'display_name' => 'Radiant' }, { 'name' => 'dire', 'display_name' => 'Dire' }])
      game['image_url'].should match(/http:\/\/.*\/assets\/dota2.jpg/)
    end
  end

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