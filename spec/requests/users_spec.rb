require 'rails_helper'

RSpec.describe 'Users Api', type: :request do
  let(:user) { create(:user) }
  let(:token) { auth_user(user) }
  describe 'POST /users' do
    let(:valid_attributes) { { email: 'valid@example.com', password: 'password', first_name: 'Luc', last_name: 'Abayo' } }
    context 'when request is valid' do
      before { post '/api/v1/users', params: valid_attributes }
      it 'should create user' do
        expect(response).to have_http_status(201)
        expect(json['message']).to eql('User registered successuflly')
        data = json['data']
        expect(data['email']).to eql('valid@example.com')
        expect(data['first_name']).to eql('Luc')
        expect(data['last_name']).to eql('Abayo')
      end
    end
    context 'when request is invalid' do
      before { post '/api/v1/users', params: { first_name: 'luc' } }
      it 'should not create user' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /users/current' do
    it 'should return current user' do
      get '/api/v1/users/current', headers: { 'Authorization' => token }
      expect(response).to have_http_status(:ok)
      expect(json['data']['email']).to eql(user.email)
    end

    it 'should return unauthorized for invalid token' do
      get '/api/v1/users/current', headers: { 'Authorization' => 'akdjf' }
      expect(response).to have_http_status(401)
    end

    it 'should return with unauthorized for unverified account' do
      user = User.create(email: "me#{Time.now.to_i}@example.com", password: 'password')
      token = auth_user(user)
      get '/api/v1/users/current', headers: { 'Authorization' => token }
      expect(response).to have_http_status(:forbidden)
      expect(json['message']).to eql('Please verify your account first!')
    end
  end
end
