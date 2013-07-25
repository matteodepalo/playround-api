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

  validates :foursquare_id, uniqueness: { allow_nil: true }
  validates :lonlat, uniqueness: true
  validates :latitude, numericality: { greater_than:  -90, less_than:  90, allow_nil: true }, presence: true
  validates :longitude, numericality: { greater_than: -180, less_than: 180, allow_nil: true }, presence: true

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }

  scope :near, -> (longitude, latitude) {
    where("ST_DWithin(lonlat, ST_MakePoint(?, ?), 50000)", longitude, latitude)
  }

  delegate :latitude, to: :lonlat, allow_nil: true
  delegate :longitude, to: :lonlat, allow_nil: true

  private

  def populate_data_from_foursquare
    venue = FOURSQUARE_CLIENT.venue(foursquare_id)
    self.name = venue.name
    self.lonlat = "POINT(#{venue.location.lng} #{venue.location.lat})"
  end
end
