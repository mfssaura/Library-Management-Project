class BookHistoriesController < ApplicationController
  before_action :find_book_history, only: [:show, :edit, :update, :destroy]

  def index
    @book_histories = BookHistory.all 
    @data = params[:data]
  end

  def new
    @book_history = BookHistory.new
  end 

  def create
    @book_history = BookHistory.new(book_history_params)
    if @book_history.save
      redirect_to @book_history, notice: 'Book History successfully created!'
    else
      render 'new', notice: 'Unable to create book history, try again'
    end
  end 

  def show
  end 

  def edit
  end 

  def update
    if @book_history.update(book_history_params)
      redirect_to @book_history, notice: 'Book History was successfully updated!'
    else
      render 'edit', notice: 'Unable to update, try again'
    end
  end 

  def destroy
    @book_history.destroy
    redirect_to book_histories_path, notice: 'Book history deleted!'
  end 

  private

  def find_book_history
    @book_history = BookHistory.find(params[:id])
  end

  def book_history_params
    params.require(:book_history).permit(:book_id, :check_out_date, :check_in_date, :user_id)
  end
end
