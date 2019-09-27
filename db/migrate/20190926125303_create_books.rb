class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books, id: :uuid do |t|
      t.integer :page_number, null: false
      t.string :title, null: false, unique: true
      t.string :language, null: false 
      t.text :description
      t.string :isbn, null:false, unique: true 
      t.integer :inventory, null: false, default: 1
      t.datetime :published_at
      t.string :publishers, array: true, default:[]
      t.timestamps
    end
  end
end
