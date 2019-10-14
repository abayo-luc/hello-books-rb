require 'rails_helper'

RSpec.describe 'Profiles' do
  let(:admin) { create(:user, role: 'admin') }
  let(:user) { create(:user) }
  let(:admin_token) { auth_user(admin) }
  let(:user_token) { auth_user(user) }
  describe 'GET /profiles' do
    it 'should response with profiles' do
      get '/api/v1/profiles', headers: { 'Authorization' => admin_token }
      expect(response).to have_http_status(:ok)
      expect(json.keys).to contain_exactly('message', 'data')
    end
    it 'should respond with authorization error' do
      get '/api/v1/profiles', headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /profiles/:id' do
    it 'should return profile if user exist' do
      get "/api/v1/profiles/#{user.id}", headers: { 'Authorization' => admin_token }
      expect(response).to have_http_status(:ok)
    end
    it 'should return profile if user exist' do
        get '/api/v1/profiles/27e15aa2-fc3a-42b3-abd0-eef3bbfb7c30', headers: { 'Authorization' => admin_token }
        expect(response).to have_http_status(:not_found)
      end
  end

  describe 'PUT /profiles/current'  do
    it 'should update current user profile' do
      put '/api/v1/profiles/update', params: {
        first_name: 'Luc',
        last_name: 'Abayo',
        phone_number: '0789277275'
      }, headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:ok)
      expect(json['data']['first_name']).to eql('Luc')
      expect(json['data']['last_name']).to eql('Abayo')
    end
    it 'should not update profile for invalid phone number' do
      put '/api/v1/profiles/update', params: {
        phone_number: '0789277275898h'
      }, headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
