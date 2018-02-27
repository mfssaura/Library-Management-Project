class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :isbn
      t.boolean :is_borrowed
      t.boolean :is_deleted
      t.boolean :is_requested
      t.boolean :requested_by
      t.timestamps null: false
    end
  end
end
