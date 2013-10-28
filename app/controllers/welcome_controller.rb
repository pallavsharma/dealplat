class WelcomeController < ApplicationController

  def index
    @marker = Marker.new
    render :layout => "logged_user", :template => "welcome/map" if user_signed_in?
  end


end
