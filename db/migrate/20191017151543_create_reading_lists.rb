class CreateReadingLists < ActiveRecord::Migration[6.0]
  def change
    create_table :readings, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :book_id, null: false
      t.string :status, default: 'pending'
      t.timestamps
    end
    add_index :readings, :book_id
    add_index :readings, :user_id
  end
end
