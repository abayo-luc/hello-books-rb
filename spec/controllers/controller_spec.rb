# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'Base API Url' do
    before { get :index, format: :json }
    it 'should return with status 200' do
      expect(response).to have_http_status(200)
      expect(json['message']).to eq('Welcome to Hello-Books API')
    end
  end
end
