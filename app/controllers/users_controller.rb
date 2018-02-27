class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index 
    @users = User.all
  end 

  def new
    @user = User.new
  end 

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User created successfully' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end 
    end 
  end 

  def show
  end 

  def edit
  end 

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Profile successfully Updated' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end 
    end 
  end 

  def destroy
    user_books = Book.find_by(user_id: @user.id)
    if user_books == nil
      @user.destroy
      flash[:notice] = 'User was successfully deleted'
      redirect_to users_url
    else
      flash[:danger] = 'Checked out! cannot delete'
      redirect_to users_url
    end
  end 

  private

  def find_user
    @user = User.find(params[:id])
  end 

  def user_params
    params.require(:user).permit(:name, :email, :password, :address, :phone, :is_admin, :is_deleted)
  end 

end