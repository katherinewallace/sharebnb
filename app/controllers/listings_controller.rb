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
    @listing = Listing.includes(:date_ranges).find(params[:id])
    until @listing.date_ranges.length == 3
      @listing.date_ranges.build
    end
    render :edit
  end
  
  def update
    @listing = Listing.includes(:date_ranges).find(params[:id])
    
    
    date_range_attributes = params[:date_range_attributes].values.reject do |range| 
        range["start_date"].empty? || range["end_date"].empty?
    end

    ActiveRecord::Base.transaction do
      @listing.assign_attributes(params[:listing])
      date_ranges = []
    
    
      date_range_attributes.each do |dr_attribute|
        if dr_attribute[:id]
          date_range = DateRange.find(dr_attribute[:id])
          date_range.assign_attributes(dr_attribute)
        
          date_ranges << date_range
        else
          date_ranges << @listing.date_ranges.new(dr_attribute)
        end
      end

      date_ranges.each { |dr| dr.save }
      if @listing.valid? && date_ranges.all? { |dr| dr.valid? }
        @listing.save
      else
        flash.now[:errors] = @listing.errors.messages.values
        date_ranges.each do |range|
          unless range.valid?
            flash.now[:errors].concat(range.errors.messages.values)
            break
          end
        end
        until @listing.date_ranges.length == 3
          @listing.date_ranges.build
        end
        render :edit
        return
      end

    end
    
    redirect_to @listing
  
  end
  
  def destroy
    
  end
  
  def calendar
    @listing = Listing.includes(:date_ranges).find(params[:id])
  end
end