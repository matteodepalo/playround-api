class ParticipationSerializer < ActiveModel::Serializer
  attributes :joined, :team
  has_one :user
end
