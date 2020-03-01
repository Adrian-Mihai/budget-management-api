RSpec.describe ApplicationController, type: :controller do
  describe 'POST #authenticate' do
    subject { post :authenticate, params: { application: { email: email, password: password } } }

    context 'when user exist' do
      let(:user) { FactoryBot.create(:user) }
      let(:email) { user.email }

      context 'when password param math user password' do
        let(:password) { user.password }
        let(:token) { 'mock-token' }

        before do
          allow(Token::Jwt::Encode).to receive(:call).with(user_uuid: user.uuid, user_email: email).and_return(token)
        end

        it { should have_http_status(:created) }

        it 'should return the encoded token' do
          subject
          expect(JSON.parse(response.body, symbolize_names: true)).to eq(token: token)
        end
      end

      context 'when password param do not match user password' do
        let(:password) { 'mock-password' }

        it { should have_http_status(:unauthorized) }

        it 'should return a error message' do
          subject
          expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: I18n.t('errors.unauthenticated'))
        end
      end
    end

    context 'when user do not exist' do
      let(:email) { Faker::Internet.safe_email }
      let(:password) { Faker::Internet.password }

      before { allow(User).to receive(:find_by!).and_raise(ActiveRecord::RecordNotFound, 'User not found') }

      it { should have_http_status(:not_found) }

      it 'should return a error message' do
        subject
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: 'User not found')
      end
    end
  end
end
