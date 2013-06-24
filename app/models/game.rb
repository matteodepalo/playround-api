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

class Game < ActiveRecord::Base
  VALID_GAME_NAMES = [:dota2, :table_football, :go]
  class InvalidGameNameError < StandardError; end

  has_many :rounds

  validates :name, inclusion: { in: VALID_GAME_NAMES }, uniqueness: true, presence: true

  class << self
    def build(options)
      if VALID_GAME_NAMES.map(&:to_s).include?(options[:name].to_s)
        "Games::#{options[:name].to_s.camelize}".constantize.new(options)
      else
        raise InvalidGameNameError
      end
    end

    def build_and_create(options)
      game = build(options)
      game.save
      game
    end
  end

  def name
    super.to_sym
  end

  def name=(name)
    super(name.to_s)
  end

  def teams
    team_names.zip(team_display_names).map do |team|
      { name: team[0], display_name: team[1] }
    end
  end
end
