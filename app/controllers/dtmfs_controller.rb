class DtmfsController < ApplicationController
  def show
    respond_to do |format|
      headers["Cache-Control"] = "no-cache"
      format.gsm { send_file "public/dtmf/#{params[:id]}.gsm", :type => "audio/x-gsm" }
    end
  end
end
