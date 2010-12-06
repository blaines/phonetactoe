class Game
  include Mongoid::Document
  field :available, :type => Boolean
  field :active, :type => Boolean
  field :spaces, :type => Hash
  references_many :players
  embeds_many :turns
  
  def setup
    self.spaces = {"1" => false, "2" => false, "3" => false, "4" => false, "5" => false, "6" => false, "7" => false, "8" => false, "9" => false}
  end
  
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
