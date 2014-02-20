class UsersController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      login(@user)
      flash[:success] = "You have been signed up!  Take a minute to add more information to your profile"
      redirect_to edit_user_url(@user)
    else
      flash.now[:errors] = @user.errors.messages.values
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
    render :edit
  end
  
  def update
    params[:user].delete("password") if params[:user][:password] == "******"
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated!"
      redirect_back_or_home
    else
      flash[:errors] = @user.errors.messages.values
      render :edit
    end
  end
  
end