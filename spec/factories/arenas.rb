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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :arena do
    name 'Meme Coworking'
    latitude 45.54231
    longitude 12.23170
  end
end
