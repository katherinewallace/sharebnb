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
    
    begin
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
        
        if @listing.valid? && date_ranges.all? { |dr| dr.valid? }
          @listing.save
          date_ranges.each { |dr| dr.save }
        else
          flash.now[:errors] = @listing.errors.messages.values
          date_ranges.each do |range|
            flash.now[:errors].concat(range.errors.messages.values)
          end
          render :edit
          return
        end
      end
      
    rescue ActiveRecord::Rollback
      # render :edit
      # raise "Rescued"
      # return
    end
    
    redirect_to @listing
    
    # date_range_attributes.each do |dr_attribute|
    #   if dr_attribute[:id]
    #     fail
    #     @listing.date_ranges.find(dr_attribute[:id]).assign_attributes(dr_attribute)
    #   else
    #     @listing.date_ranges.new(dr_attribute)
    #   end
    # end
    
    # date_ranges = []
    # 
    # date_range_attributes.each do |range_attrs| 
    #   date_ranges << (!range_attrs[:id].empty? ? DateRange.find(range_attrs[:id]).assign_attributes(range_attrs) : DateRange.new(range_attrs))
    #   # @listing.date_ranges.find_or_initialize_by(range_attrs[:id], range_attrs)
    # end
    # 
    # @listing.date_ranges = date_ranges
    # if @listing.save
    #   redirect_to listing_url(@listing)
    # else  
     
    #   render :edit
    # end
  end
  
  def destroy
    
  end
  
  def calendar
    @listing = Listing.includes(:date_ranges).find(params[:id])
  end
end