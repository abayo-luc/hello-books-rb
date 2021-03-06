require 'rails_helper'

RSpec.describe 'Books API' do
  let!(:books) { create_list(:book, 5) }
  let(:book_id) { books.first.id }
  let(:user_token) { auth_user(create(:user)) }
  let(:admin_token) { auth_user(create(:user, role: 'admin')) }
  let(:second_id) { create(:book).id }
  let(:book_attributes) do
    { title: Faker::Book.unique.title,
      isbn: Faker::Number.unique.number(digits: 10), language: 'French', page_number: 385 }
  end
  describe 'GET /books' do
    before do
      get '/api/v1/books?limit=20', headers: {
        'Authorization' => user_token
      }
    end
    it 'user should get all book' do
      expect(response).to have_http_status(200)
      expect(json.keys).to contain_exactly('message', 'data')
      expect(json['data'].size >= 5).to be_truthy
    end

    it 'shoult return 401 error' do
      get '/api/v1/books'
      expect(response).to have_http_status(401)
    end
    it 'shoult return 401 error' do
      get '/api/v1/books?category=Tech', headers: { 'Authorization' => user_token }
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /books/:id' do
    context 'when id is valid' do
      it 'should return single book' do
        get "/api/v1/books/#{book_id}", headers: {
          'Authorization' => user_token
        }
        expect(response).to have_http_status(200)
        expect(json.keys).to contain_exactly('message', 'data')
        expect(json['data'].keys).to include('title', 'isbn', 'language', 'page_number')
      end

      it 'shoult reutrn not found' do
        get '/api/v1/books/tyuiaf', headers: {
          'Authorization' => user_token
        }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PUT /books/:id' do
    context 'when is admin' do
      it 'shoult update book' do
        title = 'If You Go Down Like Economy'
        put "/api/v1/books/#{book_id}", params: { title: title },
                                        headers: {
                                          'Authorization' => admin_token
                                        }
        expect(response).to have_http_status(200)
        expect(json['data']['title']).to eql(title)
      end
      it 'should return title arleady taken' do
        book = Book.create(title: 'Imigani Nyarwanda', language: 'Kinyarwanda', isbn: Time.now.to_i, page_number: 123)
        put "/api/v1/books/#{book_id}", params: { title: book.title },
                                        headers: {
                                          'Authorization' => admin_token
                                        }
        expect(response).to have_http_status(:bad_request)
        expect(json['errors']['title']).to contain_exactly('has already been taken')
      end
      it 'should return not found' do
        put "/api/v1/books/#{book_id}kajf", headers: {
          'Authorization' => admin_token
        }
        expect(response).to have_http_status(404)
      end
    end

    context 'when is not admin' do
      before do
        put "/api/v1/books/#{book_id}", headers: {
          'Authorization' => user_token
        }
      end
      it 'should return unthorized' do
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'POST /books' do
    context 'when is admin' do
      before do
        post '/api/v1/books', params: book_attributes,
                              headers: { 'Authorization' => admin_token }
      end
      it 'shoult add a new book' do
        expect(response).to have_http_status(201)
        expect(json.keys).to contain_exactly('message', 'data')
        expect(json['data']['inventory']).to eql(1)
      end
      it 'shoult return validation error' do
        post '/api/v1/books', params: {}, headers: { 'Authorization' => admin_token }
        expect(response).to have_http_status(400)
        expect(json.keys).to contain_exactly('message', 'errors')
        expect(json['errors'].keys).to contain_exactly('title', 'isbn', 'language', 'page_number')
      end
      it 'shoult return validation error on invalid categories' do
        post '/api/v1/books', params: { **book_attributes, categories: 'hello word' }, headers: { 'Authorization' => admin_token }
        expect(response).to have_http_status(400)
        expect(json.keys).to contain_exactly('message', 'errors')
        expect(json['errors']).to contain_exactly('Categories should be an array of strings')
      end
    end
  end

  describe 'DELETE /books/:id' do
    context 'when is admin' do
      it 'should delete book successuflly' do
        delete "/api/v1/books/#{second_id}",
               headers: {
                 'Authorization' => admin_token
               }
        expect(response).to have_http_status(204)
      end
      it 'should return not found' do
        delete "/api/v1/books/#{second_id}90",
               headers: {
                 'Authorization' => admin_token
               }
        expect(response).to have_http_status(404)
      end

      it 'shoult return access denied' do
        delete "/api/v1/books/#{second_id}",
               headers: {
                 'Authorization' => user_token
               }
        expect(response).to have_http_status(403)
      end
    end
  end
end
