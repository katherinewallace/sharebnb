class NotificationsController < ApplicationController
  
  def index
    @user_notifications = Notification.includes(:noteworthy)
                                      .where(user_id: current_user.id, noteworthy_type: "User")
                                      .order("created_at DESC")
                                      .to_a
    
    @booking_notifications = Notification.includes(noteworthy: [:host, :listing])
                                      .where(user_id: current_user.id, noteworthy_type: "Booking")
                                      .order("created_at DESC")
                                      .to_a
    
    @notifications = Kaminari.paginate_array((@user_notifications + @booking_notifications).sort_by { |notification| notification.created_at }.reverse).page(params[:page])
    # @notifications = Notification.includes(:noteworthy).where(user_id: current_user.id).order("created_at DESC").to_a).page(params[:page])
    render :index
    @notifications.each do |notification|
      if notification.new
        notification.new = false
        notification.save!
      end
    end
  end
  
end