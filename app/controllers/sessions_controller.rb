class SessionsController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
    if @user
      login(@user)
      redirect_back_or_home
    else
      flash.now[:errors] = [["Invalid email/password combination"]]
      @user = User.new(params[:user][:email])
      render :new
    end
  end
  
  def destroy
    logout
    redirect_to root_url
  end
  
end