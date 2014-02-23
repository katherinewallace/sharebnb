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
  
  def unread_badge
    @unread ||= Notification.unread(current_user)
    if @unread > 0
      "<strong id=\"badge\">#{@unread}</strong>".html_safe
    else
      ""
    end
  end
end
