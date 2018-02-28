class Search < ActiveRecord::Base

  def search_books
    books = Book.all 
    books = books.where("isbn LIKE ? and title LIKE ? and description LIKE ? and author LIKE ?
                        and is_deleted = ?", "%#{isbn}","%#{title}", "%#{description}", "%#{author}", false)
    return books
  end
  
end
