class SessionsController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    auth = request.env['omniauth.auth']
    if auth
      @user = User.find_by_uid(auth[:uid])
      unless @user
        @user = User.update_or_create_from_fb(auth)
      end
    else
      @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    end
    
    if @user
      login(@user)
      flash[:success] = "Welcome #{@user.full_name}!"
      redirect_back_or_home
    else
      flash.now[:errors] = [["Invalid email/password combination"]]
      @user = User.new(email: params[:user][:email])
      render :new
    end
    
  end
  
  def destroy
    logout
    flash[:success] = "You have been logged out!"
    redirect_to root_url
  end
  
end