class ApiKeySerializer < ActiveModel::Serializer
  self.root = 'token'
  embed :ids, include: true
  attribute :access_token, key: :value
  has_one :user
end
