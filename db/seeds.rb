Game::VALID_GAME_NAMES.each do |game_name|
  Game.build_and_create(name: game_name)
end