RSpec.describe 'Password', type: :request do
  let(:user) { create(:user) }
  describe 'POST /users/password' do
    context 'if provided email exist' do
      it 'should send reset password instructions' do
        post '/api/v1/users/password', params: { email: user.email }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'if provided email does not exist' do
      it 'should respond with 404' do
        post '/api/v1/users/password', params: { email: "#{Time.now.to_i}@#{Faker::Device.manufacturer.downcase!}.com" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /users/password' do
    context 'if provided token is valid' do
      before(:example) do
        @user = User.create(email:
            "#{Time.now.to_i}@#{Faker::Device.manufacturer.downcase!}.com",
                            password: Faker::String.random(length: 8))
        @user.send_reset_password_instructions
      end
      it 'should not update without password params' do
        put "/api/v1/users/password?token=#{@user.reset_password_token}"
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly("Password can't be blank")
      end

      it 'should not update without password params' do
        put "/api/v1/users/password?token=#{@user.reset_password_token}", params: {
          password: 'password', password_confirmation: 'qwerty'
        }
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly("Password confirmation doesn't match Password")
      end

      it 'should update password with valid params' do
        put "/api/v1/users/password?token=#{@user.reset_password_token}", params: {
          password: 'password', password_confirmation: 'password'
        }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if provided token is invalid' do
      it 'should return error' do
        put "/api/v1/users/password?token=#{Faker::Internet.slug}#{Time.now.to_i}"
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly('Invalid or expired token')
      end
    end
  end
end
