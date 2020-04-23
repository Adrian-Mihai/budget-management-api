RSpec.describe Authenticate::TransactionsController do
  subject { post :create, params: { transaction: { operator: :+, amount: 1, description: 'test', creation_date: Time.zone.now } } }

  describe 'POST #create' do
    let!(:user) { create(:user) }

    before { allow(Token::Jwt::Decode).to receive(:call).and_return({ user_uuid: user.uuid }) }

    it { should have_http_status(:created) }

    it 'should create a Transaction' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    context 'when parameters are invalid' do
      subject { post :create, params: { transaction: { operator: '', amount: -1, description: 'test', creation_date: Time.zone.now } } }

      it { should have_http_status(:unprocessable_entity) }
    end
  end
end
