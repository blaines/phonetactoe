class Turn
  include Mongoid::Document
  embedded_in :game, :inverse_of => :turns
  referenced_in :player
end