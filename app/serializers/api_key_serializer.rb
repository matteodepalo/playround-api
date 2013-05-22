class ApiKeySerializer < ActiveModel::Serializer
  self.root = 'token'
  attribute :access_token, key: :value
  has_one :user
end
