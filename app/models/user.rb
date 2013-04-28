# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :api_keys

  def self.authenticate(token, options)
    self.joins(:api_keys).where(api_keys: { access_token: token }).first
  end
end
