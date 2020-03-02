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
end
