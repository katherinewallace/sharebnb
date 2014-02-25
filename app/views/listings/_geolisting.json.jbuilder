json.key_format! ->(key){ key.gsub(/_/, "-") }

json.array!(listings) do |listing|
  json.type "Feature"
  json.geometry do
    json.type "Point"
    json.coordinates [listing.longitude, listing.latitude]
  end
  json.properties do 
    json.title "<a href=\'#{listing_url(listing)}\'>#{listing.title}</a>"
    json.description "$#{listing.price} per night"
    json.marker_color "#fc4353"
    json.marker_size "large"
  end
end