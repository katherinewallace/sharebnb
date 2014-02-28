class NotificationsController < ApplicationController
  
  def index
    @notifications = Kaminari.paginate_array(Notification.includes(:noteworthy).where(user_id: current_user.id).order("created_at DESC").to_a).page(params[:page])
    render :index
    Notification.where("user_id = ? AND new = true", current_user.id).update_all(new: false)
  end
  
end