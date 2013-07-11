class TeamSerializer < ActiveModel::Serializer
  attributes :name, :winner, :display_name
  has_many :participations
end
