# == Schema Information
#
# Table name: users
#
#  id            :uuid             not null, primary key
#  name          :string(255)
#  email         :string(255)
#  image         :string(255)
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
  has_many :participations, as: :user
  has_many :rounds, through: :participations
  has_and_belongs_to_many :buddies, class_name: 'User', foreign_key: 'buddy_id', join_table: 'users_buddies', association_foreign_key: 'user_id'

  validates :name, presence: true

  def self.authenticate(token)
    self.joins(:api_keys).where(api_keys: { access_token: token }).first
  end

  def self.find_or_create_by_facebook_oauth(info)
    self.where(facebook_id: info['id']).first_or_create do |user|
      user.email = info['email']
      user.name = "#{info['first_name']} #{info['last_name']}"
      user.image = "http://graph.facebook.com/#{info['id']}/picture?type=square"
    end
  end
end
