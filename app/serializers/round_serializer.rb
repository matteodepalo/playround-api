class RoundSerializer < ActiveModel::Serializer
  attributes :id, :state
  has_one :game
  has_many :participations
end
