RSpec.describe Authenticate::Users::TransactionsController do
  subject { post :create, params: { transaction: { operator: :+, amount: 1, description: 'test' } } }

  describe 'POST #create' do
    let!(:user) { create(:user) }
    let!(:budget) { create(:budget, user: user) }

    before { allow(Token::Jwt::Decode).to receive(:call).and_return({ user_uuid: user.uuid }) }

    it { should have_http_status(:created) }

    it 'should create Transactions' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    context 'when parameters are invalid' do
      subject { post :create, params: { transaction: { operator: '', amount: -1, description: 'test' } } }

      it { should have_http_status(:unprocessable_entity) }
    end
  end
end
