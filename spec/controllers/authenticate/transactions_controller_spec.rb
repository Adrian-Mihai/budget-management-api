RSpec.describe Authenticate::TransactionsController do
  describe 'GET #index' do
    let!(:user) { create(:user) }
    let(:user_id) { user.uuid }
    let(:page) { 1 }

    subject { get :index, params: { user_id: user_id, page: page } }

    context 'when the jwt auth succeed' do
      let!(:transaction) { create(:transaction, user: user) }

      let(:expected_response) do
        {
          transactions: [{
            uuid: transaction.uuid,
            amount: transaction.amount.format,
            date: transaction.creation_date.strftime('%d-%m-%Y %T'),
            description: transaction.description,
            operator: transaction.operator
          }],
          total_pages: 1
        }
      end

      before { allow(Token::Jwt::Decode).to receive(:call).and_return({ user_uuid: user.uuid }) }

      it { should have_http_status(:ok) }

      it 'should return the expected response' do
        subject

        expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected_response)
      end

      context 'paginate' do
        let!(:transactions) { create_list(:transaction, 30, user: user) }
        let(:page) { 2 }

        before do
          Kaminari.configure do |config|
            config.default_per_page = 25
          end
        end

        it 'should return the correct total page number' do
          subject

          expect(JSON.parse(response.body, symbolize_names: true)[:total_pages]).to eq(2)
        end

        it 'should paginate correct transactions' do
          subject

          expect(JSON.parse(response.body, symbolize_names: true)[:transactions].size).to eq(6)
        end
      end
    end

    context 'when user_id do not match jwt payload' do
      let(:user_id) { 1 }

      before { allow(Token::Jwt::Decode).to receive(:call).and_return({ user_uuid: user.uuid }) }

      it { should have_http_status(:unauthorized) }

      it 'should respond with a error message' do
        subject
        expect(JSON.parse(response.body, symbolize_names: true)).to eq(error: I18n.t('errors.unauthenticated'))
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

  describe 'POST #create' do
    let(:data) { { transaction: { operator: :+, amount: 1, description: 'test', creation_date: Time.zone.now } } }

    subject { post :create, params: data }

    let!(:user) { create(:user) }

    before { allow(Token::Jwt::Decode).to receive(:call).and_return({ user_uuid: user.uuid }) }

    it { should have_http_status(:created) }

    it 'should create a Transaction' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    context 'when parameters are invalid' do
      let(:data) { { transaction: { operator: '', amount: -1, description: 'test', creation_date: Time.zone.now } } }

      it { should have_http_status(:unprocessable_entity) }
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
