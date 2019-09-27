require 'rails_helper'

RSpec.describe 'Category Request', tye: :request do
  let(:categories) { create_list(:category, 10) }
  let(:user_token) { auth_user(create(:user, role: 'admin')) }
  let(:admin_token) { auth_user(create(:user, role: 'super_admin')) }
  describe 'GET /categories' do
    it 'should get all categories' do
      get '/api/v1/categories', headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'POST /categories' do
    context 'when is super_admin' do
      it 'should create new category' do
        post '/api/v1/categories', params: { name: "hello #{Time.now}" },
        headers: {
            'Authorization' => admin_token
        }
        expect(response).to have_http_status(:created)
      end
    end
    context 'when is not super admin' do
      it 'should create new category' do
        post '/api/v1/categories', params: { name: "hello #{Time.now}" },
        headers: {
            'Authorization' => user_token
        }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /categories' do
    context 'when is super_admin' do
      it 'should create new category' do
        delete "/api/v1/categories/#{categories.first.id}",
        headers: {
            'Authorization' => admin_token
        }
        expect(response).to have_http_status(:ok)
      end
    end
    context 'when id is invalid' do
      it 'should create new category' do
        delete '/api/v1/categories/hello',
        headers: {
            'Authorization' => admin_token
        }
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when is not super admin' do
      it 'should create new category' do
        delete "/api/v1/categories/#{categories.second.id}",
        headers: {
            'Authorization' => user_token
        }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
