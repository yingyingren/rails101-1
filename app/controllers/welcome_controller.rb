class WelcomeController < ApplicationController
  def index
    flash[:warning]= "警告 "

  end
end
