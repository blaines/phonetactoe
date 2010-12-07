class Game
  include Mongoid::Document
  field :available, :type => Boolean
  field :active, :type => Boolean
  field :turn, :type => Boolean
  field :spaces, :type => Hash
  field :player_one
  field :player_two
  references_many :players
  embeds_many :turns
  
  def setup
    self.spaces = {"1" => nil, "2" => nil, "3" => nil, "4" => nil, "5" => nil, "6" => nil, "7" => nil, "8" => nil, "9" => nil}
    self.turn = true
    self.purgatory
    self.next_turn
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
  
  def next_turn
    if self.turn
      self.turn=false
    else
      self.turn=true
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
    one = self.players.find(self.player_one)
    one.game = nil
    two = self.players.find(self.player_two)
    two.game = nil
    self.active = false
    self.available = false
    true
  end
  def finished?
    if active && available
      false # Game IS finished
    else
      true
    end
  end
  
  def over?
    
    if
      self.spaces["1"] == true && self.spaces["2"] == true && self.spaces["3"] == true ||
      self.spaces["4"] == true && self.spaces["5"] == true && self.spaces["6"] == true ||
      self.spaces["7"] == true && self.spaces["8"] == true && self.spaces["9"] == true ||
      
      self.spaces["1"] == true && self.spaces["4"] == true && self.spaces["7"] == true ||
      self.spaces["2"] == true && self.spaces["5"] == true && self.spaces["8"] == true ||
      self.spaces["3"] == true && self.spaces["6"] == true && self.spaces["9"] == true ||
      
      self.spaces["1"] == true && self.spaces["5"] == true && self.spaces["9"] == true ||
      self.spaces["7"] == true && self.spaces["5"] == true && self.spaces["3"] == true ||
      
      
      
      self.spaces["1"] == false && self.spaces["2"] == false && self.spaces["3"] == false ||
      self.spaces["4"] == false && self.spaces["5"] == false && self.spaces["6"] == false ||
      self.spaces["7"] == false && self.spaces["8"] == false && self.spaces["9"] == false ||
      
      self.spaces["1"] == false && self.spaces["4"] == false && self.spaces["7"] == false ||
      self.spaces["2"] == false && self.spaces["5"] == false && self.spaces["8"] == false ||
      self.spaces["3"] == false && self.spaces["6"] == false && self.spaces["9"] == false ||
      
      self.spaces["1"] == false && self.spaces["5"] == false && self.spaces["9"] == false ||
      self.spaces["7"] == false && self.spaces["5"] == false && self.spaces["3"] == false ||
      
      self.spaces.has_value?(nil) == false
      
      true
    else
      false
    end
  end
    
    def winner?
      case
      when
        self.spaces["1"] == true && self.spaces["2"] == true && self.spaces["3"] == true ||
        self.spaces["4"] == true && self.spaces["5"] == true && self.spaces["6"] == true ||
        self.spaces["7"] == true && self.spaces["8"] == true && self.spaces["9"] == true ||

        self.spaces["1"] == true && self.spaces["4"] == true && self.spaces["7"] == true ||
        self.spaces["2"] == true && self.spaces["5"] == true && self.spaces["8"] == true ||
        self.spaces["3"] == true && self.spaces["6"] == true && self.spaces["9"] == true ||

        self.spaces["1"] == true && self.spaces["5"] == true && self.spaces["9"] == true ||
        self.spaces["7"] == true && self.spaces["5"] == true && self.spaces["3"] == true
        
        Player.find(self.player_one)
      when
        self.spaces["1"] == false && self.spaces["2"] == false && self.spaces["3"] == false ||
        self.spaces["4"] == false && self.spaces["5"] == false && self.spaces["6"] == false ||
        self.spaces["7"] == false && self.spaces["8"] == false && self.spaces["9"] == false ||

        self.spaces["1"] == false && self.spaces["4"] == false && self.spaces["7"] == false ||
        self.spaces["2"] == false && self.spaces["5"] == false && self.spaces["8"] == false ||
        self.spaces["3"] == false && self.spaces["6"] == false && self.spaces["9"] == false ||

        self.spaces["1"] == false && self.spaces["5"] == false && self.spaces["9"] == false ||
        self.spaces["7"] == false && self.spaces["5"] == false && self.spaces["3"] == false

        Player.find(self.player_two)
      when self.spaces.has_value?(nil) == false
        nil
      end
    
  end
end
