require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  describe 'POST /users' do
    let(:valid_attributes) {  { email: 'valid@example.com', password: 'password', first_name: 'Luc', last_name: 'Abayo' } }
    context 'when request is valid' do
      before { post '/v1/users', params: valid_attributes  }
      it 'should create user' do
        expect(response).to have_http_status(201)
        expect(json['message']).to eql('User registered successuflly')
        data = json['data']
        expect(data['email']).to eql('valid@example.com')
        expect(data['first_name']).to eql('Luc')
        expect(data['last_name']).to eql('Abayo')
      end
    end
    context 'when request is invalid' do
      before { post '/v1/users', params: { first_name: 'luc' } }
      it 'should not create user' do
        expect(response).to have_http_status(400)
      end
    end
  end
end
