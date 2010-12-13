class DtmfsController < ApplicationController
  def show
    respond_to do |format|
      format.gsm { send_file "public/dtmf/#{params[:id]}.gsm", :type => "audio/x-gsm" }
    end
  end
end
