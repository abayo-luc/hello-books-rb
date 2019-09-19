# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController do
  describe "Get /" do
    before { get :index, format: :json }
    it "should return with status 200" do
      parsed_response = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(parsed_response["message"]).to eq("Welcome to Hello-Books API")
    end
  end
end
