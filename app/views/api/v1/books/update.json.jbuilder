json.message('Book updeted successfully')
json.data(@book,
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
    :updated_at)
