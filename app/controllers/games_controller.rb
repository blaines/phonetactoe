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
    player = Player.first(:conditions => {:phone_number => params[:From].to_i})
    game = player.game
    # game = @game = Game.find(params[:id])
    
    
    
    
    verb = Twilio::Verb.new { |v|
          v.say 'Digit accepted'
    }

    respond_to do |format|
      if player.save
        logger.info "Game updated"
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { render :xml => verb.response } # , :status => :created
      else
        logger.info "Game update error"
        format.html { render :action => "edit" }
        format.xml  { render :xml => player.errors, :status => :unprocessable_entity }
      end
    end


    # @game = Game.find(params[:id])
    # 
    # respond_to do |format|
    #   if @game.update_attributes(params[:game])
    #     format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
    #     format.xml  { head :ok }
    #   else
    #     format.html { render :action => "edit" }
    #     format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
    #   end
    # end
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
