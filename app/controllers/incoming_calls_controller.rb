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
    
    game = Game.find(:conditions => {:available => true})
    unless game
      game = Game.new
    end
    player = Player.find_or_create_by(:phone_number => params[:From].to_i)
    player.caller = params[:Caller]
    player.game = game
    player.save
    verb = Twilio::Verb.new { |v|
        v.gather(:action => '/game_turn_path', :method => 'POST', :timeout => "90", :numDigits => 1) {
          v.say 'Pick a position'
        }
        v.say "We didn't receive any input. Goodbye!"
    }

    respond_to do |format|
      if player.save
        logger.info "Incoming call received"
        format.xml  { render :xml => verb.response } # , :status => :created
      else
        logger.info "Incoming call error"
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
