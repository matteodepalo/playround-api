require 'spec_helper'

describe 'Arenas Requests' do
  describe 'GET /arenas/1' do
    it 'returns the requested arena' do
      arena = create :arena
      get api_v1_arena_path(arena)

      response.status.should eq(200)
      response.body.should include(arena.id.to_s)
      response.body.should include(arena.name)
    end
  end

  describe 'GET /arenas' do
    it 'returns the list of arenas' do
      arena = create :arena
      get api_v1_arenas_path

      response.status.should eq(200)
    end
  end
end