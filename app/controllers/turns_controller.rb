class TurnsController < ApplicationController
  # GET /turns
  # GET /turns.xml
  def index
    @turns = Turn.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @turns }
    end
  end

  # GET /turns/1
  # GET /turns/1.xml
  def show
    @turn = Turn.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @turn }
    end
  end

  # GET /turns/new
  # GET /turns/new.xml
  def new
    @turn = Turn.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @turn }
    end
  end

  # GET /turns/1/edit
  def edit
    @turn = Turn.find(params[:id])
  end

  # POST /turns
  # POST /turns.xml
  def create
    @turn = Turn.new(params[:turn])

    respond_to do |format|
      if @turn.save
        format.html { redirect_to(@turn, :notice => 'Turn was successfully created.') }
        format.xml  { render :xml => @turn, :status => :created, :location => @turn }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @turn.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /turns/1
  # PUT /turns/1.xml
  def update
    @turn = Turn.find(params[:id])

    respond_to do |format|
      if @turn.update_attributes(params[:turn])
        format.html { redirect_to(@turn, :notice => 'Turn was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @turn.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /turns/1
  # DELETE /turns/1.xml
  def destroy
    @turn = Turn.find(params[:id])
    @turn.destroy

    respond_to do |format|
      format.html { redirect_to(turns_url) }
      format.xml  { head :ok }
    end
  end
end
