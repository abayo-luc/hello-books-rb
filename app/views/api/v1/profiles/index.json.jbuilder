json.message('Success')
json.data @profiles do |profile|
  json.call(profile,
                :id,
                :name,
                :email,
                :role,
                :bio,
                :phone_number,
                :address,
                :avatar)
end
