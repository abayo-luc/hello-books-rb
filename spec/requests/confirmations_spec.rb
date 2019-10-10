require 'rails_helper'

RSpec.describe 'Confirmation', type: :request do
  let(:user) { User.create(email: Faker::Internet.unique.email, password: 'password') }
  let(:confrimed_user) { create(:user) }
  describe 'POST /user/confirmation' do
    context 'When email exist' do
      it 'should send confirmation if not confirmed' do
        post '/api/v1/users/confirmation', params: { email: user.email }
        expect(response).to have_http_status(:ok)
        expect(json['message']).to eql('Account confirmation instructions sent successuflly')
      end
      it 'should not send confirmation if already confiremd' do
        put '/api/v1/users/confirmation', params: { email: confrimed_user.email }
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly('Acount already verified')
      end
    end
    context 'when email does not exit' do
      it 'should return not found' do
        post '/api/v1/users/confirmation', params: { email: Faker::Internet.unique.email }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT /user/confirmation' do
    context 'when token does exist' do
      it 'should confirm user, if not confirmed' do
        new_user = User.create(email: Faker::Internet.unique.email, password: 'password')
        put "/api/v1/users/confirmation?token=#{new_user.confirmation_token}"
        expect(response).to have_http_status(:ok)
        expect(json['message']).to eql('Account confirmed successuflly')
      end
      it 'should not confirm user, if alreayd confirmed' do
        new_user = User.create(email: Faker::Internet.unique.email, password: 'password')
        new_user.confirm
        put "/api/v1/users/confirmation?token=#{new_user.confirmation_token}"
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly('Acount already verified')
      end
    end
    context 'when token does not exist' do
      it 'should not confirm user, if alreayd confirmed' do
        put '/api/v1/users/confirmation?token=wertyuiop'
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']).to contain_exactly('Invalid or expired token')
      end
    end
  end
end
