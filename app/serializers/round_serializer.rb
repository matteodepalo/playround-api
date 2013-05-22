class RoundSerializer < ActiveModel::Serializer
  attributes :id, :state
  has_one :game
end
