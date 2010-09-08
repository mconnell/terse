require 'test_helper'
require 'game_server'

class GameServerTest < ActiveSupport::TestCase

  def setup
    @server = GameServer.new
  end

  def teardown
    Game.delete_all
  end

  test "add_games loads games that don't exist" do
    assert_equal([], @server.games)
    game = Game.create
    @server.add_games

    assert_equal([game], @server.games)
  end

  test "add_games doesn't add games that already exist in the server" do
    assert_equal([], @server.games)
    existing_game = Game.create
    @server.add_games

    new_game = Game.create
    @server.add_games
    assert_equal([existing_game, new_game], @server.games)
  end
end
