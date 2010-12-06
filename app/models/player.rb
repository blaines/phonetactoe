class Player
  include Mongoid::Document
  field :phone_number, :type => Integer
  field :caller, :type => String
  referenced_in :game
end
