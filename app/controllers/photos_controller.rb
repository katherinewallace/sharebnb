class PhotosController < ApplicationController
  
  def new
    @listing = Listing.find(params[:listing_id])
    @photos = []
    3.times { @photos << (@listing.photos.build) }
    render :new
  end
  
  def create
    @listing = Listing.find(params[:listing_id])
    photo_attributes = params[:photo_attributes].values.reject do |photo| 
      photo["photo_file"].nil?
    end
    @listing.photos.new(photo_attributes)
    if @listing.save
      redirect_to listing_photos_url(@listing)
    else
      @photos = @listing.photos.order(:ord_num).to_a
      flash[:errors] = []
      @photos.each do |photo|
        flash[:errors].concat(photo.errors.messages.values)
      end
      until @photos.length >= 3  do
        @photos << (@listing.photos.build)
      end
      fail
      render :new
    end
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    if request.xhr?
      head :ok 
    else
      redirect_to listing_photos_url(@photo.listing)
    end
  end
  
  def index
    @listing = Listing.find(params[:listing_id])
    @photos = @listing.photos.sort
  end
  
  def primary
    @photo = Photo.find(params[:id])
    @photo.primary = true
    @photo.ord_num = 0
    @photo.save!
    @others = @photo.listing.photos.where("id !=?", @photo.id)
    @others.each do |other| 
      if other.primary
        other.primary = false
        other.ord_num = 50
        other.save!
      end
    end
    redirect_to listing_photos_url(@photo.listing.id)
  end
  
end