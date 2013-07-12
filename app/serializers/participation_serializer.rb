class ParticipationSerializer < ActiveModel::Serializer
  attributes :joined
  has_one :user
end
