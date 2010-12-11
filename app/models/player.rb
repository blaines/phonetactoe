class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  field :phone_number, :type => Integer
  field :caller, :type => String
  referenced_in :game
end
