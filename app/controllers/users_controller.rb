class UsersController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      login(@user)
      redirect_back_or_home
    else
      flash.now[:errors] = @user.errors.messages.values
      render :new
    end
  end
  
end