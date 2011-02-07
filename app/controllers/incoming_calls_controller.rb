class IncomingCallsController < ApplicationController
  # GET /incoming_calls
  # GET /incoming_calls.xml
  def index
    
    # Call in
    # Create Player
    # Available Game?
    # Create if none avail
    # wait for other player
    # goto game
    # Take turns
    # game fin
    
    #  Grid
    # |---|---|---|
    # | 1 | 2 | 3 |
    # |---|---|---|
    # | 4 | 5 | 6 |
    # |---|---|---|
    # | 7 | 8 | 9 |
    # |---|---|---|    
    
    
    # {"ToState"=>"IL", "CalledState"=>"IL", "Direction"=>"inbound", "FromState"=>"AZ", "AccountSid"=>"AC1afaeecf73a8e05e32c695eac213226c", "Caller"=>"+16025125552", "CallerZip"=>"85013", "CallerCountry"=>"US", "From"=>"+16025125552", "FromCity"=>"PHOENIX", "CallerCity"=>"PHOENIX", "To"=>"+18152165378", "FromZip"=>"85013", "FromCountry"=>"US", "ToCity"=>"KANKAKEE", "CallStatus"=>"ringing", "CalledCity"=>"KANKAKEE", "CallerState"=>"AZ", "CalledZip"=>"60914", "ToZip"=>"60914", "ToCountry"=>"US", "CallSid"=>"CA0dbc5c273fc9923f103ab923c9e187b3", "CalledCountry"=>"US", "Called"=>"+18152165378", "ApiVersion"=>"2010-04-01"}
    
    @incoming_calls = IncomingCall.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incoming_calls }
    end
  end

  # GET /incoming_calls/1
  # GET /incoming_calls/1.xml
  def show
    @incoming_call = IncomingCall.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incoming_call }
    end
  end

  # GET /incoming_calls/new
  # GET /incoming_calls/new.xml
  def new
    @incoming_call = IncomingCall.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incoming_call }
    end
  end

  # GET /incoming_calls/1/edit
  def edit
    @incoming_call = IncomingCall.find(params[:id])
  end

  # POST /incoming_calls
  # POST /incoming_calls.xml
  def create
    logger.info "[Application] Incoming call #{params[:From]}"
    incoming_number = params[:From].to_i
    if incoming_number == 18152165378 # The application phone number
      player_phone_number = params[:To].to_i
    else
      player_phone_number = incoming_number
    end
      
    player = Player.find_or_create_by(:phone_number => player_phone_number)
    player.caller = params[:Caller]
    player.save
    
    logger.info("[Application] Player ID: #{player.id}")
    logger.info("[Application] Game ID: #{player.game.id}") if player.game
    logger.info("[Application] Game Active: #{player.game.active}") if player.game
    logger.info("[Application] Game Dead: #{player.game.dead?}") if player.game
    
    if player.game && player.game.active && !player.game.dead?
      
      # Game.any_of({:updated_at.gt => Time.now - 10.minutes, :active => true}, {:updated_at.gt => Time.now - 2.minutes, :active => false})
      # player.hungup = false # This is done when the player is called again
      logger.info("[Application] Picking player's current game")
      game = player.game
    else
      logger.info("[Application] Picking first game available")
      game = Game.first(:conditions => {:available => true})
    end
    
    logger.info("[Application] Current player count: #{game.players.count}") if game
    
    if game
      # Add player 2 to game
      if game.players.count == 1 && game.players.first.id != player.id
        logger.info("[Application] Adding player two to game")
        game.player_two = player.phone_number
        player.game = game
        game.start
        game.save
      end
    else
      logger.info("[Application] Creating new game")
      game = Game.new
      game.setup
      player.game = game
      game.player_one = player.phone_number
      game.available = true
    end
    game.save
    player.save
    
    verb = Twilio::Verb.new { |v|
      v.redirect "/games/#{game.id}/gather.xml"
    }
    
    respond_to do |format|
      if player.save
        format.xml  { render :xml => verb.response } # , :status => :created
      else
        logger.info "[Application] Incoming call error"
        format.xml  { render :xml => player.errors, :status => :unprocessable_entity }
      end
    end

    
    # @incoming_call = IncomingCall.new(params[:incoming_call])
    # 
    # respond_to do |format|
    #   if @incoming_call.save
    #     format.html { redirect_to(@incoming_call, :notice => 'Incoming call was successfully created.') }
    #     format.xml  { render :xml => @incoming_call, :status => :created, :location => @incoming_call }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @incoming_call.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  # PUT /incoming_calls/1
  # PUT /incoming_calls/1.xml
  def update
    @incoming_call = IncomingCall.find(params[:id])

    respond_to do |format|
      if @incoming_call.update_attributes(params[:incoming_call])
        format.html { redirect_to(@incoming_call, :notice => 'Incoming call was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incoming_call.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def hangup
    if params[:From]
      player = Player.find_or_create_by(:phone_number => params[:From].to_i)
      if player.game && player.game.active && player.game.available
        player.game.destroy # Unstage
        player.game = nil # playing it safe
        # player.game_id = nil # playing it safe
        Twilio.connect('AC1afaeecf73a8e05e32c695eac213226c', '2f4d4a952c4d0bdfa9b9d40266b6b81d')
        Twilio::Sms.message("(815) 216-5378", "+#{player.phone_number}", 'Get a friend to join in!')
        #  Want a call back when the game is ready? (Yes or No)
      elsif player.game && player.game.active && !player.game.available
        player.hungup = true # jerk! :)
      end
      player.save
    end
    respond_to do |format|
        format.xml  { head :ok }
    end
  end

  # DELETE /incoming_calls/1
  # DELETE /incoming_calls/1.xml
  def destroy
    @incoming_call = IncomingCall.find(params[:id])
    @incoming_call.destroy

    respond_to do |format|
      format.html { redirect_to(incoming_calls_url) }
      format.xml  { head :ok }
    end
  end
end
