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
    foursquare_id '5104'
    name 'Clinton St. Baking Co. & Restaurant'
    latitude 40.721294
    longitude -73.983994
  end
end
