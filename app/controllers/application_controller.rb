class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SessionsHelper
  
  def login(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    @current_user = user
  end
  
  def logout
    current_user.reset_session_token!
    session[:session_token] = nil
    clear_return_to
  end
  
  def remember_location
    session[:return_to] = request.url if request.get?
  end
  
  def redirect_back_or_home
    redirect_to(session[:return_to] || root_url)
    clear_return_to
  end
  
  def clear_return_to
    session.delete(:return_to)
  end
  
  def require_signed_in
    unless current_user
      remember_location
      redirect_to new_session_url
    end
  end
  
end
