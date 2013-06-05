class Buddyship < ActiveRecord::Base
  belongs_to :user
  belongs_to :buddy, class_name: 'User'

  validate :user_id_and_buddy_id_must_be_different

  private

  def user_id_and_buddy_id_must_be_different
    errors.add(:base, 'user_id and buddy_id must be different') unless user_id != buddy_id
  end
end
