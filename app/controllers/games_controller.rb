class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => 'Game was successfully created.') }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])
    
    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def gather
    player = Player.first(:conditions => {:phone_number => params[:From].to_i})
    game = player.game
    # game = @game = Game.find(params[:id])
    
    
    if game.over? == false
    
    verb = Twilio::Verb.new { |v|
        if params["Digits"]
          v.say params["Digits"]
          game.next_turn
        else
          v.say "Waiting for other player"
          v.pause :length => 2
        end
        
        if (player.id.to_s == game.player_one && game.turn==true) || (player.id.to_s == game.player_two && game.turn==false)
          v.gather(:action => "/games/#{game.id}/gather.xml", :method => 'POST', :timeout => "90", :numDigits => 1) {
            v.say 'Pick a position'
          }
          v.say "We didn't receive any input. Goodbye!"
        else
        v.redirect "/games/#{game.id}/gather.xml"
      end
      
      case
      when player.id.to_s == game.player_one && params["Digits"]
        logger.info("Marking for player ONE 111111")
        if game.spaces[params["Digits"]] == nil
          game.spaces[params["Digits"]] = true
        else
          v.say "Position taken"
        end
      when player.id.to_s == game.player_two && params["Digits"]
        logger.info("Marking for player TWO 222222")
        if game.spaces[params["Digits"]] == nil
          game.spaces[params["Digits"]] = false
        else
          v.say "Position taken"
        end
      end

    }
    
    end
    
    respond_to do |format|
      if game.save
        logger.info "Game updated"
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { render :xml => verb.response } # , :status => :created
      else
        logger.info "Game update error"
        format.html { render :action => "edit" }
        format.xml  { render :xml => player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end
