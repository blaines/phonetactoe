class Game
  include Mongoid::Document
  field :available, :type => Boolean
  field :active, :type => Boolean
  references_many :players
  embeds_many :turns
  
  def purgatory
    self.active = true
    self.available = true
  end
  def start
    self.active = true
    self.available = false
  end
  def finish
    self.active = false
    self.available = false
  end
  def finished?
    if active && available
      false # Game IS finished
    else
      true
    end
  end
end
