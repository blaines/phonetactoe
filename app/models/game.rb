class Game
  include Mongoid::Document
  field :available, :type => Boolean
  references_many :players
  embeds_many :turns
end
