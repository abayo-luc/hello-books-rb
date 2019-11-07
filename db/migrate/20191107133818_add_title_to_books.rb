class AddTitleToBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :books, :cover_image, :string, default: 'https://res.cloudinary.com/dghepsznx/image/upload/v1549123906/WhatIf/placeholder-image.jpg'
  end
end
