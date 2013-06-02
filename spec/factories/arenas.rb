# == Schema Information
#
# Table name: arenas
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :arena do
    name 'Meme Coworking'
    latitude 45.54231
    longitude 12.23170
  end
end
