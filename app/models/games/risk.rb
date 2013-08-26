module Games
  class Risk < Game
    def display_name
      'Risk'
    end

    def image_file
      'risk.jpg'
    end

    def teams
      [
        { name: 'red', display_name: 'Red', number_of_players: 1 },
        { name: 'green', display_name: 'Green', number_of_players: 1 },
        { name: 'black', display_name: 'Red', number_of_players: 1 },
        { name: 'blue', display_name: 'Green', number_of_players: 1 },
        { name: 'yellow', display_name: 'Red', number_of_players: 1 },
        { name: 'pink', display_name: 'Green', number_of_players: 1 }
      ]
    end
  end
end
