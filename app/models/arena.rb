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

class Arena < ActiveRecord::Base
  has_many :rounds

  validate :foursquare_id, presence: true, uniqueness: true
  validate :latitude, numericality: { greater_than:  -90, less_than:  90 }, presence: true
  validate :longitude, numericality: { greater_than: -180, less_than: 180 }, presence: true

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }

  private

  def populate_data_from_foursquare
    venue = FOURSQUARE_CLIENT.venue(foursquare_id)
    self.name = venue.name
    self.latitude = venue.location.lat
    self.longitude = venue.location.lng
  end
end
