json.message('Success')
json.data(@book,
          :id,
          :title,
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
