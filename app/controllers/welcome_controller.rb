class WelcomeController < ApplicationController

  def index
    @marker = Marker.new
    render :layout => "backbone_application", :template => "welcome/map" if user_signed_in?
  end


end
