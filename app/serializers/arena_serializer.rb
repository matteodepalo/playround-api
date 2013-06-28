class ArenaSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :foursquare_id
end
