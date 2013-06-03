class UserSerializer < ActiveModel::Serializer
  self.root = 'user'
  attributes :id, :name, :image
end