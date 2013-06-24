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

    def team_names
      ['black', 'white']
    end

    def team_display_names
      ['Black', 'White']
    end
  end
end
