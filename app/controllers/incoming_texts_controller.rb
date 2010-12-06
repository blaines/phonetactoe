class IncomingTextsController < ApplicationController
  # GET /incoming_texts
  # GET /incoming_texts.xml
  def index
    @incoming_texts = IncomingText.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @incoming_texts }
    end
  end

  # GET /incoming_texts/1
  # GET /incoming_texts/1.xml
  def show
    @incoming_text = IncomingText.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @incoming_text }
    end
  end

  # GET /incoming_texts/new
  # GET /incoming_texts/new.xml
  def new
    @incoming_text = IncomingText.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @incoming_text }
    end
  end

  # GET /incoming_texts/1/edit
  def edit
    @incoming_text = IncomingText.find(params[:id])
  end

  # POST /incoming_texts
  # POST /incoming_texts.xml
  def create
    # {"ToState"=>"IL", "FromState"=>"AZ", "AccountSid"=>"AC1afaeecf73a8e05e32c695eac213226c", "SmsMessageSid"=>"SM8a1e2f65484fa1bd45b6a37d72a145fe", "Body"=>"youre an idiot sometimes", "From"=>"+16234556356", "FromCity"=>"PHOENIX", "SmsStatus"=>"received", "FromZip"=>"85065", "FromCountry"=>"US", "To"=>"+18152165378", "ToCity"=>"KANKAKEE", "ToZip"=>"60914", "ToCountry"=>"US", "ApiVersion"=>"2010-04-01", "SmsSid"=>"SM8a1e2f65484fa1bd45b6a37d72a145fe"}
    @incoming_text = IncomingText.new(params[:incoming_text])

    respond_to do |format|
      if @incoming_text.save
        format.html { redirect_to(@incoming_text, :notice => 'Incoming text was successfully created.') }
        format.xml  { render :xml => @incoming_text, :status => :created, :location => @incoming_text }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @incoming_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /incoming_texts/1
  # PUT /incoming_texts/1.xml
  def update
    @incoming_text = IncomingText.find(params[:id])

    respond_to do |format|
      if @incoming_text.update_attributes(params[:incoming_text])
        format.html { redirect_to(@incoming_text, :notice => 'Incoming text was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @incoming_text.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /incoming_texts/1
  # DELETE /incoming_texts/1.xml
  def destroy
    @incoming_text = IncomingText.find(params[:id])
    @incoming_text.destroy

    respond_to do |format|
      format.html { redirect_to(incoming_texts_url) }
      format.xml  { head :ok }
    end
  end
end
