# == Schema Information
#
# Table name: arenas
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  foursquare_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  location      :spatial({:srid=>
#
# Indexes
#
#  index_arenas_on_foursquare_id  (foursquare_id) UNIQUE
#  index_arenas_on_location       (location)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :arena do
    foursquare_id '5104'
    name 'Clinton St. Baking Co. & Restaurant'
    location_geographic [-73.983994, 40.721294]
  end
end
