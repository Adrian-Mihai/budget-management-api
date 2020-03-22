RSpec.describe Transactions::Create do
  subject { described_class.new(user_id: user.id, parameters: parameters).call }

  describe '.call' do
    let!(:user) { create(:user) }
    let(:parameters) do
      {
        uuid: SecureRandom.uuid,
        operator: :+,
        amount: 1,
        description: 'Tet'
      }
    end

    it 'should create a new Transaction' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    it 'should create a new Budget' do
      expect { subject }.to change { Budget.count }.by(1)
    end

    it 'should update user budget amount' do
      subject
      expect(user.budget.reload.amount).to eq(Money.new(100))
    end

    include_examples 'valid and not contain errors'

    context 'when parameter are invalid' do
      let(:parameters) { nil }

      include_examples 'not valid and contain errors'
    end
  end
end
