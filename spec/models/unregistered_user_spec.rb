# == Schema Information
#
# Table name: unregistered_users
#
#  id            :uuid             not null, primary key
#  facebook_id   :string(255)
#  foursquare_id :string(255)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_unregistered_users_on_facebook_id    (facebook_id)
#  index_unregistered_users_on_foursquare_id  (foursquare_id)
#

require 'spec_helper'

describe UnregisteredUser do
  it 'is valid with either a facebook_id or a foursquare_id' do
    UnregisteredUser.new(foursquare_id: '123').should be_valid
    UnregisteredUser.new(facebook_id: '123').should be_valid
    UnregisteredUser.new(facebook_id: '123', foursquare_id: '456').should_not be_valid
  end
end
