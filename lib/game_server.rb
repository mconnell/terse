require File.expand_path('../../config/environment', __FILE__)

class GameServer
  attr_accessor :games

  def initialize
    self.games = []
  end

  def add_games
    current_game_ids = games.map{|g| g.id }
    Game.all.each do |game|
      self.games << game unless current_game_ids.include?(game.id)
    end
  end

  #def self.start_game(game)
    # while !game.finished? do
    #   next_round(game)
    #   sleep 60
    # end
  #end

  #private
  #def self.next_round(game)
    # create round
    # select_next_artist
    # select_next_word
    # start round (push to clients, start timer)
  #end
end

#$running = true
#while $running do
  # game_server.every 30.seconds
  #   add_games
  #   start_games
  # end
#end
##
# every 30.seconds
# - GameServer.add_games
# receive draw
# - push drawing out to clients if permitted

# receive guess
# - push guess

# callback for creating a game? || creates a game

# start a game
# - pick a word
# - pick an artist
# - notify clients

# round end

# round start