class BooksController < ApplicationController
  before_action :find_book, only: [:show, :edit, :destroy, :update]

  def index
    @books = Book.all.order('created_at DESC')
  end 

  def new
    @book = Book.new
  end 

  def create
    @book = Book.new(book_params)
    @book.is_deleted = false
    if @book.save
      redirect_to @book, notice: 'Book was successfully added!'
    else
      render 'new'
    end 
  end 

  def show
  end 

  def edit
  end 

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book was successfully updated!'
    else
      render :edit, notice: 'Error is updating, try again!'
    end 
  end 

  def destroy
    if @book.present?
      @book.is_deleted = true
      @book.save
      redirect_to books_path, notice: 'Book was successfully destroyed!'
    else
      render :new, notice: 'Error in deleting, try again!'
    end
  end 

  def borrow
    @book = Book.find(params[:id])
    @book.is_borrowed = true
    @book.user_id = session[:user_id]

    if @book.save
      redirect_to @book, notice: 'Book is borrowed'
    else
      render 'new'
    end 

    #Create check out history of book
    create_book_history(params[:id], session[:user_id], Time.zone.now)
  end

  def create_book_history(book_id, user_id, check_out_date)
    @book_history = BookHistory.new
    @book_history.book_id = book_id
    @book_history.user_id = user_id
    @book_history.check_out_date = check_out_date
    @book_history.save!
  end 

  def return
    @book = Book.find(params[:id])
    invalid_return = false
    if @book.is_borrowed && (@book.user_id != @current_user.id)
      invalid_return = false
    end 
    send_mail = false
    if @book.is_requested
      user = User.find(@book.requested_by)
      send_mail = true
    end 

    @book.is_borrowed = false
    @book.user_id = nil
    @book.requested_by = nil
    @book.is_requested = false

    if !invalid_return and @book.save!
      redirect_to @book, notice: 'Booking was successfully borrowed!'
    else
      render 'show', notice: 'Invalid Action'
    end

    if send_mail
      send_email_to_requester(user, @book.title)
    end 

    complete_book_history(params[:id], session[:user_id], Time.zone.now)
  end

  def send_email_to_requester(user, bookname)
    Notifier.send_notification(user.email, user.name, book_name).deliver_now!
  end

  def complete_book_history(book_id, user_id, check_in_date)
    @book_history = BookHistory.find_by(book_id: book_id, user_id: user_id, check_in_date: nil)
    @book_history.check_in_date = check_in_date
    @book_history.save
  end

  def request_book
    @book = Book.find(params[:id])
    @book.is_requested = true 
    @book.requested_by = session[:user_id]
    if @book.save!
      render :show, status: :ok, location: @book 
    else
      render :show
    end 
  end 

  def cancel_request
    @book = Book.find(params[:id])
    @book.is_requested = false
    @book.requested_by = nil 
    if @book.save
      render :show, status: :ok, location: @book 
    else
      render :show
    end
  end

  def calc_fine
    @book = Book.find(params[:id])
    @fine = 0
    no_of_days = (@book.check_in_date.strftime("%Y-%m-%d") - @book.check_out_date.strftime("%Y-%m-%d"))
    if (@book.is_requested and no_of_days > 15.days) 
      @fine += (no_of_days)*0.05
    end 
  end 

  private

  def find_book
    @book = Book.find(params[:id])
  end 

  def book_params
    params.require(:book).permit(:title, :description, :author, :isbn, :is_borrowed, :is_deleted)
  end

end
