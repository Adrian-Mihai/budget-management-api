RSpec.describe Authenticate::UsersController, type: :controller do
  describe 'GET #decode' do
    subject { get :decode }

    let(:payload) do
      {
        user_uuid: SecureRandom.uuid,
        user_email: Faker::Internet.safe_email,
        exp: Integer(Time.current)
      }
    end
    let!(:user) { FactoryBot.create(:user, uuid: payload[:user_uuid]) }

    before { allow(Token::Jwt::Decode).to receive(:call).and_return(payload) }

    it { should have_http_status(:ok) }

    it 'should return the decoded token' do
      subject
      expect(JSON.parse(response.body, symbolize_names: true)).to eq(payload.except(:exp))
    end

    context 'when user do not exist' do
      let(:payload) { { user_uuid: SecureRandom.uuid } }

      before { allow(User).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound, 'Couldn\'t find User') }

      it { should have_http_status(:not_found) }

      it 'should respond with a error message' do
        subject
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: 'Couldn\'t find User')
      end
    end

    context 'when token decode raise a error' do
      before { allow(Token::Jwt::Decode).to receive(:call).and_raise(JWT::DecodeError.new('Session expired')) }

      it { should have_http_status(:unauthorized) }

      it 'should respond with a error message' do
        subject
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: 'Session expired')
      end
    end
  end
end
