class TeamSerializer < ActiveModel::Serializer
  attributes :name, :winner, :display_name, :number_of_players
  has_many :participations
end
