json.array!(@pending_bookings+ @confirmed_bookings) do |booking| 
  json.id booking.id
  json.listing_id booking.listing_id
  json.start_date booking.start_date
  json.end_date booking.end_date
  json.guest_num booking.guest_num
  json.status booking.status
  json.subtotal booking.subtotal
  json.guest_fname booking.guest.fname
  json.guest_lname booking.guest.lname
  json.guest_pic_url booking.guest.profile_pic.try(:url, :small)
  json.overlaps booking.overlapping_bookings.any?
end