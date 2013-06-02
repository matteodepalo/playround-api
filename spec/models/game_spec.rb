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

require 'spec_helper'

describe Game do
  it 'valid with a game name taken from the list of valid games' do
    game = Game.new(name: :dota2)
    game.should be_valid
  end

  it 'is invalid with a game name not taken from the list of valid games' do
    game = Game.new(name: :lol)
    game.should be_invalid
  end

  it 'builds the correct game based on the name attribute' do
    game = Game.build(name: :dota2)
    game.should be_a(Games::Dota2)
  end

  it 'is invalid if the name is alreay existing' do
    game = Game.build_and_create(name: :dota2)
    game2 = Game.new(name: :dota2)
    game2.should_not be_valid
  end

  it 'raises exception when a wrong name is used' do
    expect {
      game = Game.build(name: :lol)
    }.to raise_exception
  end

  it 'gives the correct display name based on the name' do
    game = Game.build(name: :dota2)
    game.display_name.should eq('Dota 2')
  end
end
