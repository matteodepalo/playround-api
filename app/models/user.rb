# == Schema Information
#
# Table name: users
#
#  id          :uuid             not null, primary key
#  name        :string(255)
#  email       :string(255)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  facebook_id :integer
#

class User < ActiveRecord::Base
  has_many :api_keys
  has_many :hosted_rounds, class_name: 'Round'
  has_many :participants
  has_many :rounds, through: :participants

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
