class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_cache_headers
  helper_method :current_user, :logged_in?

  def current_user
    #session[:user_id] = nil
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    if current_user 
      return true
    else
      return false
    end
  end

  def require_user
    unless logged_in?
      flash[:notice] = "You are not authorised to perform this action"
      redirect_to songs_path
    end
  end
  
  
  private
  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
