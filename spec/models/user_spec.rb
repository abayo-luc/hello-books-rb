require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  subject { described_class.new(password: 'password', email: 'luc@example.com') }
  describe 'User Validation' do
    describe 'email' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.email = nil
        expect(subject).to_not be_valid
      end
      it 'must be a valid email' do
        subject.email = 'luc'
        expect(subject).to_not be_valid
      end
      it 'should validate uniqueness of email' do
        described_class.create(email: 'luc@gmail.com', password: 'password')
        user = described_class.new(email: 'luc@gmail.com', password: 'password')
        expect(user).to_not be_valid
      end
    end
    describe 'password' do
      it 'must be present' do
        expect(subject).to be_valid
        subject.password = nil
        expect(subject).to_not be_valid
      end
    end
  end
  describe '#formated_email' do # user has # for instance method and . for class methods.
    it 'returns the email in lowercase' do
      expect(subject.formated_email).to eql('luc@example.com')
    end
  end

  describe '#change_role' do
    context 'should update user role' do
      it 'if role is user' do
        expect(user.change_role('user')).to be_truthy
        expect(user.role).to eql('user')
      end
      it 'if role is admin' do
        expect(user.change_role('admin')).to be_truthy
        expect(user.role).to eql('admin')
      end
    end
    context 'should not update user if' do
      it 'role is not user or admin' do
        user.change_role('hello')
      rescue => e
        expect(e.message).to eql('Role should be user or admin')
      end
    end
  end
end
