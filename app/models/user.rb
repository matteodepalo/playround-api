# == Schema Information
#
# Table name: users
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  email       :string(255)
#  facebook_id :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_users_on_facebook_id  (facebook_id) UNIQUE
#

class User < ActiveRecord::Base
  has_many :api_keys
  has_many :hosted_rounds, class_name: 'Round'
  has_many :participations
  has_many :rounds, through: :participations
  has_many :buddyships
  has_many :buddies, class_name: 'User', through: :buddyships

  validates :name, presence: true
  validates :facebook_id, presence: true, uniqueness: { allow_nil: true }

  class << self
    def authenticate(token)
      self.joins(:api_keys).where(api_keys: { access_token: token }).first
    end

    def find_or_create_by_facebook_oauth(info)
      user = self.where(facebook_id: info['id']).first
      user_info = { name: "#{info['first_name']} #{info['last_name']}", facebook_id: info['id'] }
      user_info.merge!(email: info['email']) if info['email'].present?

      if user
        user.update(user_info)
      else
        user = User.create(user_info)
      end

      user
    end

    def find_or_create_by_hashes(user_hashes = [])
      registered_users = User.where('id IN (?) or facebook_id IN (?)', user_hashes.map { |h| h[:id] }.compact, user_hashes.map { |h| h[:facebook_id] }.compact)
      unregistered_hashes = user_hashes.select { |h| h[:facebook_id].present? && !registered_users.map(&:facebook_id).include?(h[:facebook_id]) }
      unregistered_users = []

      return registered_users unless unregistered_hashes.present?

      facebook_users = FACEBOOK_CLIENT.batch do |client|
        unregistered_hashes.each do |h|
          client.get_object(h[:facebook_id])
        end
      end

      facebook_users.each do |u|
        unregistered_users << find_or_create_by_facebook_oauth(u)
      end

      registered_users + unregistered_users
    end
  end

  def buddy_list=(buddies_hashes)
    self.buddies << User.find_or_create_by_hashes(buddies_hashes)
  end

  def picture_url
    facebook_id.present? ? "http://graph.facebook.com/#{facebook_id}/picture?type=square" : ''
  end
end
