# == Schema Information
#
# Table name: arenas
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  latitude      :float
#  longitude     :float
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
  it 'gets venute information from foursquare_id', :vcr do
    foursquare_id = '5104'
    arena = Arena.create(foursquare_id: foursquare_id)

    arena.latitude.should eq(40.721294)
    arena.longitude.should eq(-73.983994)
    arena.foursquare_id.should eq(foursquare_id)
  end
end
