class StaticPagesController < ApplicationController
  
  def home
    @search = {}
    render :home
  end
end