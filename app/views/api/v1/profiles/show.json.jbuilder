json.message('Success')
json.data(@profile,
            :id,
            :name,
            :email,
            :role,
            :bio,
            :phone_number,
            :address,
            :avatar)
