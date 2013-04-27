# == Schema Information
#
# Table name: arenas
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  latitude   :float
#  longitude  :float
#  created_at :datetime
#  updated_at :datetime
#

class Arena < ActiveRecord::Base
  has_many :rounds
end
