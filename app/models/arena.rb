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

class Arena < ActiveRecord::Base
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(srid: 4326))

  has_many :rounds

  validate :foursquare_id, uniqueness: true
  validate :lonlat, presence: true
  validate :uniqueness_of_lonlat

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }

  def latitude
    lonlat.latitude
  end

  def longitude
    lonlat.longitude
  end

  private

  def populate_data_from_foursquare
    venue = FOURSQUARE_CLIENT.venue(foursquare_id)
    self.name = venue.name
    self.lonlat = "POINT(#{venue.location.lng} #{venue.location.lat})"
  end

  def uniqueness_of_lonlat
    errors.add(:base, 'latitude and longitude must be unique') if Arena.exists?(lonlat: lonlat)
  end
end
