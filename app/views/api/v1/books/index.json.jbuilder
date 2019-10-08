json.message('Success')
json.data @books do |book|
  json.(book,
      :id,
      :title,
      :description,
      :language,
      :page_number,
      :isbn,
      :inventory,
      :categories,
      :publishers,
      :published_at,
      :created_at,
      :updated_at
  )
end
