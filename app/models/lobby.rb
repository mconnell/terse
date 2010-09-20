class Lobby
  attr_reader :channel, :id, :game

  def initialize(lobby_id)
    @channel = EM::Channel.new
    @id = lobby_id
    next_game
    start_game
  end

  def next_game
    @game = Game.new
  end

  def start_game
    EventMachine::PeriodicTimer.new(10) do
      puts "Clearing channel #{@id}"
      @channel.push ['clear', {}].to_json
      @game.finished? ? next_game : @game.next_round
      puts "Round #{@game.rounds.size}"
    end
  end
end
