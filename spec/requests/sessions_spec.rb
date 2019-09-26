require 'rails_helper'

RSpec.describe 'Session Api', type: :request do
  let(:user) { create(:user) }
  describe 'POST /sessions' do
    context 'when request is valid' do
      before { post '/api/v1/sessions', params: { email: user.email, password: 'password' } }
      it 'should login successfully' do
        expect(response).to have_http_status(200)
        expect(json['message']).to eql('Success')
        expect(json.keys).to contain_exactly('message', 'token')
      end
    end

    context 'when request is not valid' do
      before { post '/api/v1/sessions', params: { email: 'user@me.com', password: 'password' } }
      it 'should return error' do
        expect(response).to have_http_status(400)
        expect(json['error']).to eql('Invalid email or password')
      end
    end
  end
end
