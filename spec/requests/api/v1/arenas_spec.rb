require 'spec_helper'

describe 'Arenas Requests' do
  describe 'GET /arenas/1' do
    it 'returns the requested' do
      arena = create :arena
      get api_v1_arena_path(arena)
      response.status.should eq(200)
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