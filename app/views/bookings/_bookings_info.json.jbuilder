json.array!(bookings) do |booking| 
   
  json.start_date = booking.start_date
  json.end_date = booking.end_date
  json.guest_num = booking.guest_num
  json.status = booking.status
  json.subtotal = booking.subtotal
  json.guest_fname = booking.guest.fname
  json.guest_lname = booking.guest.lname
  
end
