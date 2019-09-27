class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :books_categories, id: false do |t|
      t.uuid :book_id
      t.uuid :category_id
    end
    add_index :categories, :name, unique: true
    add_index :books_categories, :book_id
    add_index :books_categories, :category_id
  end
end
