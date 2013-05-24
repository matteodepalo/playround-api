class UnregisteredUser < ActiveRecord::Base
  validate :social_id_must_be_present

  has_many :participations, class_name: 'Participant', as: :user
  has_many :rounds, through: :participations

  def social_id_must_be_present
    unless (facebook_id.present? && !foursquare_id.present?) || (!facebook_id.present? && foursquare_id.present?)
      errors.add(:base, 'You must provide either a facebook_id or a foursquare_id')
    end
  end
end
