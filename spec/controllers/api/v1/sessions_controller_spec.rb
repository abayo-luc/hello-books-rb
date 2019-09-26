require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'before actions' do
    context 'skipped action' do
      it { should use_before_action(:authenticate_request) }
    end
  end
end
