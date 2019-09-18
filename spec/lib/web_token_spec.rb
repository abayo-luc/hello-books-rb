require 'rails_helper'

RSpec.describe WebToken do
  describe 'encode and decode token' do
    context 'if valid user provided' do
      subject { described_class.encode({ id: 2, email: 'test@example.com' }) }
      it 'shoult return a valid token' do
        user = described_class.decode(subject)
        expect(user['id']).to eql(2)
        expect(user['email']).to eql('test@example.com')
      end
    end

    context 'if invalid user is provided' do
      subject { described_class.encode({}) }
      it 'shoult return token with invalid user' do
        user = described_class.decode(subject)
        expect(user['id']).to be_nil
        expect(user['id']).to be_nil
      end
    end

    context 'if invalid token is provided' do
      subject { described_class.encode({ id: 1, email: 'test@test.com' }) }
      it 'should return invalid token error' do
        described_class.decode("#{subject}hello")
      rescue => e
        expect(e.message).to eql('Invalid token')
      end
    end

    context 'if expired token is provided' do
      it 'should return expired token error' do
        token = described_class.encode({ id: 1, email: 'test@test.com' })
        now = Time.now + 4.weeks
        allow(Time).to receive(:now) { now }
        described_class.decode(token)
      rescue => e
        expect(e.message).to eql('Token has expired')
      end
    end
  end
end
