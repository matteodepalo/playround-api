# == Schema Information
#
# Table name: games
#
#  id         :uuid             not null, primary key
#  name       :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_games_on_name  (name) UNIQUE
#

module Games
  class Dota2 < Game
    def display_name
      'Dota 2'
    end

    def image_file
      'dota2.jpg'
    end

    def number_of_teams
      2
    end
  end
end
