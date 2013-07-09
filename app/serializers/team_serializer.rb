class TeamSerializer < ActiveModel::Serializer
  attributes :name
  has_many :participations
end
