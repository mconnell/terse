class Game
  include Mongoid::Document
  embeds_many :rounds
end
