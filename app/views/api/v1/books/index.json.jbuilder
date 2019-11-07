json.message('Success')
json.data @books do |book|
  json.call(book,
            :id,
            :title,
            :cover_image,
            :description,
            :language,
            :page_number,
            :isbn,
            :inventory,
            :categories,
            :authors,
            :publishers,
            :published_at,
            :created_at,
            :updated_at)
end
