class UserSerializer < ActiveModel::Serializer
  self.root = 'user'
  attributes :id, :name, :picture_url, :facebook_id
end