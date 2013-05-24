require 'spec_helper'

describe UnregisteredUser do
  it 'is valid with either a facebook_id or a foursquare_id' do
    UnregisteredUser.new(foursquare_id: '123').should be_valid
    UnregisteredUser.new(facebook_id: '123').should be_valid
    UnregisteredUser.new(facebook_id: '123', foursquare_id: '456').should_not be_valid
  end
end
