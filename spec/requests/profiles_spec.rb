require 'rails_helper'

RSpec.describe 'Profiles' do
  let(:admin) { create(:user, role: 'admin') }
  let(:user) { create(:user) }
  let(:user_token) { auth_user(create(:user, role: 'admin')) }
  describe 'GET /profiles' do
    it 'should response with profiles' do
      get '/api/v1/profiles', headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:ok)
      expect(json.keys).to contain_exactly('message', 'data')
    end
  end

  describe 'GET /profiles/:id' do
    it 'should return profile if user exist' do
      get "/api/v1/profiles/#{user.id}", headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:ok)
    end
    it 'should return profile if user exist' do
        get '/api/v1/profiles/27e15aa2-fc3a-42b3-abd0-eef3bbfb7c30', headers: { 'Authorization' => user_token }
        expect(response).to have_http_status(:not_found)
      end
  end
end
