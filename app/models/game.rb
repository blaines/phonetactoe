class Game
  include Mongoid::Document
  field :available, :type => Boolean
  field :active, :type => Boolean
  field :spaces, :type => Hash
  field :player_one
  field :player_two
  references_many :players
  embeds_many :turns
  
  def setup
    self.spaces = {"1" => nil, "2" => nil, "3" => nil, "4" => nil, "5" => nil, "6" => nil, "7" => nil, "8" => nil, "9" => nil}
    self.purgatory
  end
  
  def space(i)
    case self.spaces[i.to_s]
    when nil
      "-"
    when true
      "X"
    when false
      "O"
    end
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
