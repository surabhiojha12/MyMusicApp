class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy]
  before_action :require_same_user, only: [ :edit, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    puts "======================================"
    puts "The session id is #{session[:user_id]}"
    puts "======================================"
    @user = User.find_by_id(session[:user_id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to signin_path, notice: 'Account successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    session[:user_id] = nil
    current_user = nil
    redirect_to songs_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      require_same_user
      #redirect_to signin_path unless @user #for a route that does not exist redirect it back to home page
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :phone_no, :type_of_user, :password, :password_confirmation)
    end

    def require_same_user
      
      puts "======================================"
      puts "The session id is #{session[:user_id]}"
      if @user 
      puts "The current user id is #{@user.id}"
      end
      puts Time.now
      puts logged_in?
      puts "======================================"
      require_user
      if logged_in? && current_user != @user #session_current_user is is inherited from application controller
        flash[:notice] = "You cannot perform such actions"
        redirect_to songs_path 
      
      end
    end
    
end
