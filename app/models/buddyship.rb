# == Schema Information
#
# Table name: buddyships
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  buddy_id   :uuid
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_buddyships_on_buddy_id  (buddy_id)
#  index_buddyships_on_user_id   (user_id)
#

class Buddyship < ActiveRecord::Base
  belongs_to :user
  belongs_to :buddy, class_name: 'User'

  validate :user_id_and_buddy_id_must_be_different

  private

  def user_id_and_buddy_id_must_be_different
    errors.add(:base, 'user_id and buddy_id must be different') unless user_id != buddy_id
  end
end
