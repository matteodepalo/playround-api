require 'spec_helper'

describe 'Arenas Requests' do
  describe 'GET /v1/arenas/{id}' do
    it 'returns the requested arena' do
      arena_factory = create :arena, foursquare_id: '5104'
      get v1_arena_path(arena_factory)

      response.status.should eq(200)
      arena = JSON.parse(response.body)['arena']
      arena['id'].should eq(arena_factory.id.to_s)
      arena['foursquare_id'].should eq('5104')
      arena['name'].should eq('Clinton St. Baking Co. & Restaurant')
      arena['latitude'].should eq(40.721294)
      arena['longitude'].should eq(-73.983994)
    end
  end

  describe 'GET /v1/arenas' do
    it 'returns the list of arenas', :vcr do
      create :arena
      Arena.create(location_geographic: [50, 10])
      get v1_arenas_path

      response.status.should eq(200)
      JSON.parse(response.body)['arenas'].count.should eq(2)
    end
  end
end