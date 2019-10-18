require 'rails_helper'

RSpec.describe 'Readings API', order: :defined do
  before(:all) do
    @book = create(:book)
    @user = create(:user)
    @admin = create(:user, role: 'admin')
    @user_token = auth_user(@user)
  end
  describe 'POST /readings/books/:book_id' do
    it 'should add book to the reading list' do
      post "/api/v1/readings/books/#{@book.id}", headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:created)
    end
    it 'should not add book if already added' do
      post "/api/v1/readings/books/#{@book.id}", headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:bad_request)
    end

    it 'should return not found for invalid book id' do
      post "/api/v1/readings/books/#{@book.id}#{Time.now.to_i}", headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:not_found)
    end
  end
  describe 'GET /readings' do
    it "should return all book on current user's list" do
      get '/api/v1/readings', headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'PUT /readings/:id' do
    let(:book) { create(:book) }
    let(:reading) { Reading.create(user_id: @user.id, book_id: book.id) }
    it 'should update book on reading list to borrowed' do
      put "/api/v1/readings/#{reading.id}", headers: { 'Authorization' => auth_user(@admin) }
      expect(response).to have_http_status(:ok)
      expect(json['message']).to eql('Marked borrowed successuflly')
    end
    let(:borrowed_book) { Reading.create(user_id: @user.id, book_id: book.id, status: 'borrowed') }
    it 'should update book on reading list to returned' do
      put "/api/v1/readings/#{borrowed_book.id}", headers: { 'Authorization' => auth_user(@admin) }
      expect(response).to have_http_status(:ok)
      expect(json['message']).to eql('Marked returned successuflly')
    end
  end
  describe 'DELETE /readings/:id' do
    it 'should remove book from reading list' do
      delete "/api/v1/readings/books/#{@book.id}", headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:no_content)
    end
    it 'should return not found' do
      delete "/api/v1/readings/books/#{@book.id}", headers: { 'Authorization' => @user_token }
      expect(response).to have_http_status(:not_found)
    end
  end
end
