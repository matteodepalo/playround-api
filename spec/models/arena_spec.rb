# == Schema Information
#
# Table name: arenas
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  latlon        :spatial({:srid=>
#  foursquare_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_arenas_on_foursquare_id  (foursquare_id)
#

require 'spec_helper'

describe Arena do
  it 'has a unique couple of latitude and longitude' do
    Arena.create(location_geographic: 'POINT(50 10)')
    arena = Arena.new(location_geographic: 'POINT(50 10)')
    arena.should be_invalid
    arena.errors[:location].first.should eq('has already been taken')
  end

  it 'gets venue information from foursquare_id' do
    foursquare_id = '5104'
    arena = Arena.create(foursquare_id: foursquare_id)

    arena.latitude.should eq(40.721294)
    arena.longitude.should eq(-73.983994)
    arena.name.should eq('Clinton St. Baking Co. & Restaurant')
    arena.foursquare_id.should eq(foursquare_id)
  end

  it 'finds arenas in a radius of 50km' do
    arena = Arena.create(location_geographic: 'POINT(50 10)')
    arena2 = Arena.create(location_geographic: 'POINT(50.1 10)')
    arena3 = Arena.create(location_geographic: 'POINT(-30 -70)')

    Arena.near(50, 10).should eq([arena, arena2])
  end
end
