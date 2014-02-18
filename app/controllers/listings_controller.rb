class ListingsController < ApplicationController
  before_filter :require_signed_in
  
  def new
    @listing = Listing.new
    render :new
  end
  
  def create
    @listing = Listing.new(params[:listing])
    @listing.user_id = current_user.id
    if @listing.save
      redirect_to listings_url # change this to listing show page
    else
      flash.now[:errors] = @listing.errors.messages.values
      render :new
    end
    
  end
  
  def index
    @listings = Listing.all # change to filtered listings
    render :index
  end
  
  def show
    
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
end