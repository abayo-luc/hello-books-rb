class RenameColumnOnUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :description, :bio
  end
end
