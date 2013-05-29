# == Schema Information
#
# Table name: unregistered_users
#
#  id            :uuid             not null, primary key
#  facebook_id   :string(255)
#  foursquare_id :string(255)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_unregistered_users_on_facebook_id    (facebook_id)
#  index_unregistered_users_on_foursquare_id  (foursquare_id)
#

class UnregisteredUser < ActiveRecord::Base
  has_many :participations, class_name: 'Participant', as: :user
  has_many :rounds, through: :participations

  validate :social_id_must_be_present

  def social_id_must_be_present
    unless (facebook_id.present? && !foursquare_id.present?) || (!facebook_id.present? && foursquare_id.present?)
      errors.add(:base, 'You must provide either a facebook_id or a foursquare_id')
    end
  end
end
