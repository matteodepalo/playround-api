require 'spec_helper'

describe 'Arenas Requests' do
  describe 'GET /arenas/1' do
    it 'returns the requested arena' do
      arena_factory = create :arena, name: 'Meme Coworking', latitude: 45.54231, longitude: 12.23170
      get v1_arena_path(arena_factory)

      response.status.should eq(200)
      arena = JSON.parse(response.body)['arena']
      arena['id'].should eq(arena_factory.id.to_s)
      arena['name'].should eq('Meme Coworking')
      arena['latitude'].should eq(45.54231)
      arena['longitude'].should eq(12.23170)
    end
  end

  describe 'GET /arenas' do
    it 'returns the list of arenas' do
      arena = create :arena
      get v1_arenas_path

      response.status.should eq(200)
      JSON.parse(response.body)['arenas'].count.should eq(1)
    end
  end
end