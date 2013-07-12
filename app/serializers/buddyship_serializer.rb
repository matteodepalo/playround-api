class BuddyshipSerializer < ActiveModel::Serializer
  has_one :user
  has_one :buddy
end