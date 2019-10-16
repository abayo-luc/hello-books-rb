json.message('Success')
json.data @authors do |author|
  json.call(author, :id, :name, :country, :birth_date, :bio, :created_at, :updated_at)
end
