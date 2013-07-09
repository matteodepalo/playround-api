class RoundSerializer < ActiveModel::Serializer
  attributes :id, :state
  has_one :game
  has_one :arena
  has_many :teams
end
