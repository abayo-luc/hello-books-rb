json.message('Success')
json.data @readings do |reading|
  json.call(reading, :id, :status, :book)
end
