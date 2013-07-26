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
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:location, FACTORY.projection_factory)
  EWKB = RGeo::WKRep::WKBGenerator.new(type_format: :ewkb, emit_ewkb_srid: true, hex_format: true)

  has_many :rounds

  validates :foursquare_id, uniqueness: { allow_nil: true }
  validates :location, uniqueness: true
  validates :latitude, numericality: { greater_than:  -90, less_than:  90, allow_nil: true }, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180, allow_nil: true }, presence: true

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }

  scope :near, -> (longitude, latitude) {
    ewkb = EWKB.generate(FACTORY.point(longitude, latitude).projection)
    where("ST_DWithin(location, ST_GeomFromEWKB(E'\\\\x#{ewkb}'), 50000)")
  }

  def location_geographic
    FACTORY.unproject(location)
  end

  def location_geographic=(wkt_point)
    self.location = FACTORY.project(FACTORY.parse_wkt(wkt_point))
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
    self.location_geographic = "POINT(#{venue.location.lng} #{venue.location.lat})"
  end
end
