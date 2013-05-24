class RoundSerializer < ActiveModel::Serializer
  attributes :id, :state, :participant_list
  has_one :game
end
