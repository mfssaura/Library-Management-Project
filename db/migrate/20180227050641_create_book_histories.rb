class CreateBookHistories < ActiveRecord::Migration
  def change
    create_table :book_histories do |t|
      t.belongs_to :book, index: true
      t.belongs_to :user, index: true
      t.integer :book_id
      t.integer :user_id
      t.datetime :check_out_date
      t.datetime :check_in_date
      t.timestamps null: false
    end
  end
end
