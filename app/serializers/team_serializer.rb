class TeamSerializer < ActiveModel::Serializer
  attributes :name, :winner
  has_many :participations
end
