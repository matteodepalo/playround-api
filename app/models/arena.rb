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
  validate :latitude, numericality: { greater_than:  -90, less_than:  90 }, presence: true
  validate :longitude, numericality: { greater_than: -180, less_than: 180 }, presence: true
  validate :uniqueness_of_lonlat

  before_validation :populate_data_from_foursquare, if: -> { foursquare_id && foursquare_id_changed? }

  scope :near, -> (latitude, longitude) {
    where("ST_DWithin(lonlat, ST_MakePoint(?, ?), 50000)", longitude, latitude)
  }

  delegate :latitude, to: :lonlat
  delegate :longitude, to: :lonlat

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
