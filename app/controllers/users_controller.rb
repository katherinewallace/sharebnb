class UsersController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      self.current_user = @user
      login(@user)
      redirect_to root_url
    else
      flash[:errors] = @user.errors.full_messages
    end
  end
  
end