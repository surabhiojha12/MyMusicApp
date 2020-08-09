class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "You are logged in"
      puts "============================"
      puts "You are logged in"
      puts "============================"
      redirect_to songs_path
    else
      puts "============================"
        puts "Invalid email/password combination."
        puts "============================"
        flash.now[:notice] = "Invalid email/password combination."
        render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    current_user = nil
    redirect_to signin_path, notice: "Logged out!"
  end
end
