class RoundSerializer < ActiveModel::Serializer
  attributes :id, :state, :created_at
  has_one :game
  has_one :arena
  has_many :teams
  has_one :user
end
