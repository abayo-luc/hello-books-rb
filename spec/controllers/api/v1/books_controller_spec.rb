require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  describe 'actions' do
    it { should use_before_action(:authenticate_request) }
    it { should use_before_action(:authorize_admin) }
  end
end
