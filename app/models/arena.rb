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

class Arena < ActiveRecord::Base
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:location, FACTORY.projection_factory)
  EWKB = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, emit_ewkb_srid: true, hex_format: true)

  has_many :rounds

  validates :foursquare_id, uniqueness: { allow_nil: true }
  validates :location, uniqueness: true
  validates :latitude, numericality: { greater_than:  -90, less_than:  90, allow_nil: true }, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180, allow_nil: true }, presence: true

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }
  before_validation :populate_data_from_geocoder, if: -> { location && location_changed? && !foursquare_id }

  scope :near, -> (longitude, latitude) {
    ewkb = EWKB.generate(FACTORY.point(longitude, latitude).projection)
    where("ST_DWithin(location, ST_GeomFromEWKB(E'\\\\x#{ewkb}'), 50000)")
  }

  def location_geographic
    FACTORY.unproject(location)
  end

  def location_geographic=(lonlat = [])
    longitude = lonlat.first
    latitude = lonlat.last
    self.location = FACTORY.project(FACTORY.point(longitude, latitude))
  end

  def latitude
    location_geographic ? location_geographic.latitude.round(6) : nil
  end

  def longitude
    location_geographic ? location_geographic.longitude.round(6) : nil
  end

  private

  def populate_data_from_foursquare
    venue = FOURSQUARE_CLIENT.venue(foursquare_id)
    self.name = venue.name
    self.location_geographic = [venue.location.lng, venue.location.lat]
  end

  def populate_data_from_geocoder
    self.name = Geocoder.search([latitude, longitude]).try(:first).try(:city)
  end
end
