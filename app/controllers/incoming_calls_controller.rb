class IncomingCallsController < ApplicationController
  # GET /incoming_calls
  # GET /incoming_calls.xml
  def index
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
    @incoming_call = IncomingCall.new(params[:incoming_call])

    respond_to do |format|
      if @incoming_call.save
        format.html { redirect_to(@incoming_call, :notice => 'Incoming call was successfully created.') }
        format.xml  { render :xml => @incoming_call, :status => :created, :location => @incoming_call }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incoming_call.errors, :status => :unprocessable_entity }
      end
    end
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
