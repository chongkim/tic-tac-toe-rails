module ApplicationHelper
  def user_signed_in?
    session[:user_id]
  end
  def current_user
    @user ||= User.find(session[:user_id])
  rescue
    session[:user_id] = nil
    nil
  end
end
