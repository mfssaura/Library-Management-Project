class SessionsController < ApplicationController
  skip_before_action :verify_login

  def new
  end 

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to home_path
    else
      flash.now[:alert] = 'Invalid email id or password, Try again!'
      render 'new'
    end 
  end 

  def destroy
    log_out
    redirect_to login_path
  end 

  def signup
    @user = User.new
    render 'sessions/signup'
  end 

  def new_user
    # binding.pry
    @user = User.new(user_params)
    begin
      if @user.save
        session[:user_id] = @user.id
        logged_in?
        redirect_to home_path
      end
    rescue => error
      logger.debug "ERROR - gaurav"
      flash.now[:danger] = "#{error.message}"
      render 'signup'
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :address, :phone, :is_admin, :is_deleted)
  end 

end
