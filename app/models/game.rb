class Game
  attr_reader :rounds
  def initialize
    @rounds = []
    next_round
  end

  def next_round
    @rounds << Round.new
    # select word
    # select player
    # notify_clients
  end

  def finished?
    @rounds.size == 10
  end
end
