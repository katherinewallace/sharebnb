module ApplicationHelper
  def auth_token
    "<input 
    type=\"hidden\" 
    name=\"authenticity_token\" 
    value=\"<%= form_authenticity_token %>\"
    >".html_safe
  end
  
  def listing_owner?(listing)
    current_user && listing.user_id == current_user.id
  end
end
