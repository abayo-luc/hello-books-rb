require 'rails_helper'
RSpec.describe 'Role API', type: :request do
  describe 'PUT users/:id/roles' do
    let(:user) { create(:user) }
    let(:id) { user.id }
    let(:admin) { create(:user, role: 'super_admin') }
    context 'if is admin authenticated, with valid request' do
      before { put "/api/v1/users/#{id}/roles", params: { role: 'admin' }, headers: {
          'Authorization' => auth_user(admin)
      }}
      it 'should change user to  ' do
        expect(response).to have_http_status(200)
        expect(json['data']['role']).to eql('admin')
      end
    end
    context 'if is admin authenticated, but invalid request' do
      it 'should return not found on invalid id ' do
        put "/api/v1/users/#{id}hekloo/roles", params: { role: 'admin' }, headers: {
          'Authorization' => auth_user(admin) }
        expect(response).to have_http_status(404)
      end
      it 'should invalid rele' do
        put "/api/v1/users/#{id}/roles", params: { role: 'hello' }, headers: {
          'Authorization' => auth_user(admin) }
        expect(response).to have_http_status(400)
        expect(json['error']).to eql('Role should be user or admin')
      end
    end
  end
end
