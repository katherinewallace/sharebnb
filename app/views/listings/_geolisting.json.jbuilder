json.key_format! ->(key){ key.gsub(/_/, "-") }

geolistings = listings.reject{|listing| listing.longitude.blank? || listing.latitude.blank? }

json.array!(geolistings) do |listing|
    json.type "Feature"
    json.geometry do
      json.type "Point"
      json.coordinates [listing.longitude, listing.latitude]
    end
    json.properties do 
      json.title "<a href=\'#{listing_url(listing)}\'>#{listing.title}</a>"
      json.description "$#{listing.price} per night"
      json.marker_color "#009bf5"
      json.marker_size "large"
      json.marker_id listing.id
    end
end