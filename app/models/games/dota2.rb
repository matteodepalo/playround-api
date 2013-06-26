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

    def teams
      [
        { name: 'radiant', display_name: 'Radiant', number_of_players: 5 },
        { name: 'dire', display_name: 'Dire', number_of_players: 5 },
      ]
    end
  end
end
