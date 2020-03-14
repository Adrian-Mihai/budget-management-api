RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    subject do
      post :create, params: { user: { name: name,
                                      email: email,
                                      password: password,
                                      password_confirmation: password_confirmation } }
    end

    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.safe_email }
    let(:password) { Faker::Internet.password(min_length: 8) }
    let(:password_confirmation) { password }

    it { should have_http_status(:created) }

    it 'should create a new User instance' do
      expect { subject }.to change { User.count }.by(1)
    end

    context 'when password length is less than 8 characters' do
      let(:password) { '123456' }

      it { should have_http_status(:unprocessable_entity) }
    end

    context 'when password is not provided' do
      let(:password) { nil }

      it { should have_http_status(:unprocessable_entity) }
    end

    context 'when password_confirmation do not match password' do
      let(:password_confirmation) { Faker::Internet.password(min_length: 8) }

      it { should have_http_status(:unprocessable_entity) }
    end

    context 'when email is invalid' do
      let(:email) { 'test.example.com' }

      it { should have_http_status(:unprocessable_entity) }
    end

    context 'when email is not provided' do
      let(:email) { nil }

      it { should have_http_status(:unprocessable_entity) }
    end
  end

  describe 'POST #authenticate' do
    subject { post :authenticate, params: { user: { email: email, password: password } } }

    context 'when user exist' do
      let(:user) { create(:user) }
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
