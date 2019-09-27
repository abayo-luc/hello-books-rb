class CreateAuthors < ActiveRecord::Migration[6.0]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :name, null: false
      t.string :country
      t.text :bio
      t.datetime :birth_date
      t.timestamps
    end
    create_table :authors_books, id: false do |t|
      t.uuid :book_id
      t.uuid :author_id
    end
    add_index :authors, :name, unique: true
    add_index :authors_books, :book_id
    add_index :authors_books, :author_id
  end
end
