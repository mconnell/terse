class Game
  attr_reader :rounds, :word
  def initialize
    @rounds = []
    next_round
  end

  def next_round
    @rounds << Round.new
    # select word
    @word = 'foobar'
    # select player
    # notify_clients
  end

  def finished?
    @rounds.size == 10
  end
end
