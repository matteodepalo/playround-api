class UnregisteredUserSerializer < ActiveModel::Serializer
  attributes :id, :facebook_id, :foursquare_id
end