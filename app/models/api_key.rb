# == Schema Information
#
# Table name: api_keys
#
#  id           :uuid             not null, primary key
#  access_token :string(255)
#  user_id      :uuid
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  index_api_keys_on_access_token  (access_token) UNIQUE
#  index_api_keys_on_user_id       (user_id)
#

class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates :access_token, uniqueness: { allow_nil: true }, presence: true

  before_validation :generate_access_token, on: :create

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
  end
end
