class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  field :phone_number, :type => Integer
  field :caller, :type => String
  field :hungup, :type => Boolean
  referenced_in :game
  
  def self.find_with_params(params)
    player_phone_number = parse_player_params(params)
    Player.first(:conditions => {:phone_number => player_phone_number})
  end
  
  def self.find_or_create_with_params(params)
    player_phone_number = parse_player_params(params)
    Player.find_or_create_by(:phone_number => player_phone_number)
  end
  def parse_player_params(params)
    incoming_number = params[:From].to_i
    if incoming_number == 18152165378 # The application phone number
      params[:To].to_i
    else
      incoming_number
    end  
  end
end
