require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  describe 'before actions' do
    context 'skipped action' do
      it { should use_before_action(:authenticate_request) }
    end
  end
end
