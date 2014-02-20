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
      flash[:errors] = @listing.errors.messages.values
      render :new
    end
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to listing_photos_url(@photo.listing)
  end
  
  def index
    @listing = Listing.find(params[:listing_id])
    @photos = @listing.photos.sort
  end
  
  def primary
    @photo = Photo.find(params[:id])
    @photo.primary = true
    @photo.save!
    @others = @photo.listing.photos.where("id !=?", @photo.id)
    @others.each do |other| 
      if other.primary
        other.primary = false
        other.save!
      end
    end
    redirect_to listing_photos_url(@photo.listing.id)
  end
  
end