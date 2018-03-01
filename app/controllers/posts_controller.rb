class PostsController < ApplicationController

  def new
    @book = Book.new
    @post = @book.posts.build
  end 

  def create
    @book = Book.find(params[:book_id])
    @post = @book.posts.new(post_params)
    @post.user_id = @current_user.id
    if @post.save
      redirect_to @book, notice: 'Posted!'
    else
      render 'new', notice: 'Unable to post, try again'
    end 
  end

  def show
    @post = Post.find(params[:id])
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :book_id, :user_id)
  end 

end
