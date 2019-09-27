require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST #create' do
    it 'returns http success' do
      post :create
      expect(response).to have_http_status(401)
    end
  end
end
