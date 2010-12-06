class Game
  include Mongoid::Document
  field :available, :type => Boolean
  field :active, :type => Boolean
  field :spaces, :type => Hash
  references_many :players
  embeds_many :turns
  
  def setup
    self.spaces = {"1" => nil, "2" => nil, "3" => nil, "4" => nil, "5" => nil, "6" => nil, "7" => nil, "8" => nil, "9" => nil}
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
