class Round
  include Mongoid::Document
  embedded_in :game, :inverse_of => :rounds
  references_one :sketch
end
