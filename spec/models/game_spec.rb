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

  describe 'Dota 2' do
    it 'has radiant and dire as teams' do
      Game.build(name: :dota2).teams.should eq([
        { name: 'radiant', display_name: 'Radiant', number_of_players: 5 },
        { name: 'dire', display_name: 'Dire', number_of_players: 5 }
      ])
    end
  end

  describe 'Go' do
    it 'has black and white as teams' do
      Game.build(name: :go).teams.should eq([
        { name: 'black', display_name: 'Black', number_of_players: 1 },
        { name: 'white', display_name: 'White', number_of_players: 1 }
      ])
    end
  end

  describe 'Table football' do
    it 'has blue and red as teams' do
      Game.build(name: :table_football).teams.should eq([
        { name: 'blue', display_name: 'Blue', number_of_players: 2 },
        { name: 'red', display_name: 'Red', number_of_players: 2 }
      ])
    end
  end
end
