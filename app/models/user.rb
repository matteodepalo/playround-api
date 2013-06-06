# == Schema Information
#
# Table name: users
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  email         :string(255)
#  facebook_id   :string(255)
#  foursquare_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_users_on_facebook_id    (facebook_id)
#  index_users_on_foursquare_id  (foursquare_id)
#

class User < ActiveRecord::Base
  has_many :api_keys
  has_many :hosted_rounds, class_name: 'Round'
  has_many :participations
  has_many :rounds, through: :participations
  has_many :buddyships
  has_many :buddies, class_name: 'User', through: :buddyships

  validates :name, presence: true

  validate :social_id_must_be_present

  class << self
    def authenticate(token)
      self.joins(:api_keys).where(api_keys: { access_token: token }).first
    end

    def find_or_create_by_facebook_oauth(info)
      user = self.where(facebook_id: info['id']).first_or_create do |user|
        user.email = info['email']
        user.name = "#{info['first_name']} #{info['last_name']}"
      end
    end
  end

  def buddies_hashes=(buddies_hashes)
    buddies_hashes.each do |buddy|
      self.buddies << User.where(buddy.slice('id', 'facebook_id', 'foursquare_id')).first_or_create do |b|
        b.name = buddy[:name]
      end
    end
  end

  def image
    facebook_id.present? ? "http://graph.facebook.com/#{facebook_id}/picture?type=square" : ''
  end

  private

  def social_id_must_be_present
    unless facebook_id.present? || foursquare_id.present?
      errors.add(:base, 'Either facebook_id or foursquare_id must be present')
    end
  end
end
