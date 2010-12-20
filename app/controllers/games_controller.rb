class GamesController < ApplicationController
  
  AudioLoop = ["http://dl.dropbox.com/u/1157635/Blaine1.mp3",
  "http://dl.dropbox.com/u/1157635/Blaine2.mp3",
  "http://dl.dropbox.com/u/1157635/Blaine3.mp3"]
  
  
  # GET /games
  # GET /games.xml
  def index
    # @games = Game.all
    @games = Game.any_of({:updated_at.gt => Time.now - 10.minutes, :active => true}, {:updated_at.gt => Time.now - 2.minutes, :active => false})

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
    logger.info "[Application] (#{player.phone_number}) gather"
    game = player.game
    # game = @game = Game.find(params[:id])
    # http://phonesystem.heroku.com/games
    verb = Twilio::Verb.new { |v|


      if game.over? == false

        if params["Digits"]
          state = :digits
        elsif (player.phone_number == game.player_one && game.turn==true) || (player.phone_number == game.player_two && game.turn==false)
          state = :turn
        else
          state = :wait
        end

        case state
        when :digits
          # digits
          v.say params["Digits"]
        when :turn
          # my turn
          v.gather(:action => "/games/#{game.id}/gather.xml", :method => 'POST', :timeout => "90", :numDigits => 1) {
            v.say 'Pick a position'
            v.play AudioLoop.last
          }
          v.say "We didn't receive any input. Goodbye!"
        when :wait
          # other turn
          v.say 'Waiting for other player'
          v.play AudioLoop.first
          # Call players if hungup
          game.players.where(:hungup => true).each do |bad_person|
            logger.info "[Application] (#{player.phone_number}) #{bad_person.phone_number} hung up... we're callin em back!"
            Twilio::Call.make("(815) 216-5378", bad_person.phone_number, "http://twilio-tic-tac-toe.heroku.com/incoming_calls.xml")
            bad_person.hungup = false # We don't want to spam them!
            bad_person.save
          end
        end
        
        case
        when player.phone_number == game.player_one && params["Digits"]
          logger.info("[Application] (#{player.phone_number}) Marking for player ONE 111111")
          if game.spaces[params["Digits"]] == nil
            game.spaces[params["Digits"]] = true
            game.next_turn
          else
            v.say "Position taken"
          end
        when player.phone_number == game.player_two && params["Digits"]
          logger.info("[Application] (#{player.phone_number}) Marking for player TWO 222222")
          if game.spaces[params["Digits"]] == nil
            game.spaces[params["Digits"]] = false
            game.next_turn
          else
            v.say "Position taken"
          end
        end

        v.redirect "/games/#{game.id}/gather.xml"




      else

        v.say "Game Over!"
        
        Twilio.connect('AC1afaeecf73a8e05e32c695eac213226c', '2f4d4a952c4d0bdfa9b9d40266b6b81d')
        if game.winner? === nil
          Twilio::Sms.message("(815) 216-5378", "+#{player.phone_number}", 'No winner :(')
        elsif game.winner? == player.phone_number
          Twilio::Sms.message("(815) 216-5378", "+#{player.phone_number}", 'Congratulations! You Won!')
        else
          Twilio::Sms.message("(815) 216-5378", "+#{player.phone_number}", 'Play better next time!')
        end
                
        v.hangup

        game.finish

      end

    }

    respond_to do |format|
      if game.save
        logger.info "[Application] Game updated"
        format.html { redirect_to(@game, :notice => 'Game was successfully updated.') }
        format.xml  { render :xml => verb.response } # , :status => :created
      else
        logger.info "[Application] Game update error"
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
