class ListingsController < ApplicationController
  before_filter :require_signed_in
  before_filter :require_listing_owner, only: [:edit, :update, :destroy]
  
  def new
    @listing = Listing.new
    3.times { @listing.date_ranges.build }
    render :new
  end
  
  def create
    @listing = Listing.new(params[:listing])
    @listing.user_id = current_user.id
    date_range_attributes = params[:date_range_attributes].values.reject {
      |range| range["start_date"].empty? || range["end_date"].empty?
    }
    @listing.date_ranges.new(date_range_attributes)
    
    if @listing.save
      redirect_to listings_url # change this to listing show page
    else
      flash.now[:errors] = @listing.errors.messages.values
      until @listing.date_ranges.length === 3
        @listing.date_ranges.build
      end
      render :new
    end
    
  end
  
  def index
    @listings = Listing.all # change to filtered listings
    render :index
  end
  
  def show
    @listing = Listing.find(params[:id])
    render :show
  end
  
  def edit
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
  def calendar
    @listing = Listing.find(params[:id])
  end
end