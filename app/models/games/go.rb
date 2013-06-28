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
  class Go < Game
    def display_name
      'Go'
    end

    def image_file
      'go.jpg'
    end

    def teams
      [
        { name: 'black', display_name: 'Black', number_of_players: 1 },
        { name: 'white', display_name: 'White', number_of_players: 1 },
      ]
    end
  end
end
