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
    session[:session_token] = user.session_token
  end
end
