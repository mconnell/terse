class Lobby
  attr_reader :channel, :id, :game

  def initialize(lobby_id)
    @channel = EM::Channel.new
    @id      = lobby_id
    @game    = Game.new
    start_game
  end

  private
  def start_game
    EventMachine::PeriodicTimer.new(10) do
      clear_client_sketchpads
      start_next_round_or_game
    end
  end

  def clear_client_sketchpads
    puts "Clearing channel #{@id}"
    @channel.push ['clear', {}].to_json
  end

  def start_next_round_or_game
    if @game.finished?
      @game = Game.new
    else
      @game.next_round
    end
    puts "Round #{@game.rounds.size}"
  end
end
