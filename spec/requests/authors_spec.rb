require 'rails_helper'

RSpec.describe 'Request API' do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:user_token) { auth_user(user) }
  let(:token) { auth_user(admin) }
  describe 'GET /authors' do
    before { get '/api/v1/authors', headers: { 'Authorization' => user_token } }
    it 'should return the list of authors' do
      expect(response).to have_http_status(:ok)
    end
    it 'should have message and array of data' do
      expect(json.keys).to contain_exactly('message', 'data')
      expect(json['data'].kind_of?(Array)).to be_truthy
    end
  end
  describe 'GET /authors/:id' do
    let(:author) { create(:author) }
    context 'if ID does exist in the database' do
      before { get "/api/v1/authors/#{author.id}", headers: { 'Authorization' => user_token } }
      it 'should return author' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'if ID does not exist' do
      before { get "/api/v1/authors/#{author.id}#{Time.now.to_i}", headers: { 'Authorization' => user_token } }
      it 'should expect not found status code' do
        expect(response).to have_http_status(:not_found)
      end
      it 'should have error message' do
        expect(json['error']).to eql('Record not found')
      end
    end
  end
  describe 'PUT /authors/:id' do
    let(:author) { create(:author) }
    context 'if ID does exist in the database' do
      it 'should allow admin to update author successuflly' do
        put "/api/v1/authors/#{author.id}", params: { country:
            'Rwanda', name: Faker::Name.unique.name },
            headers: { 'Authorization' => token
        }
        expect(response).to have_http_status(:ok)
        expect(json.keys).to contain_exactly('message', 'data')
        expect(json['data']['country']).to eql('Rwanda')
      end

      it 'should return unauthorized for non admin' do
        put "/api/v1/authors/#{author.id}", headers: { 'Authorization' => user_token }
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'if ID does not exit in the database' do
      it 'should return not found(404)' do
        put "/api/v1/authors/#{author.id}-#{Time.now.to_i}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /authors/:id' do
    let(:author) { create(:author) }
    context 'if ID does exist' do
      it 'should allow admin to delete an author' do
        delete "/api/v1/authors/#{author.id}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(:no_content)
      end
      it 'should not allow user to delete author' do
        delete "/api/v1/authors/#{author.id}", headers: { 'Authorization' => user_token }
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'if ID doest not exit' do
      it 'should return not found' do
        delete "/api/v1/authors/#{author.id}-#{Time.now.to_i}", headers: { 'Authorization' => token }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
