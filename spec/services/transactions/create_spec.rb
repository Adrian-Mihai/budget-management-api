RSpec.describe Transactions::Create do
  subject { described_class.new(parameters: parameters).call }

  describe '.call' do
    let!(:budget) { create(:budget, amount: 1) }
    let(:parameters) do
      {
        budget_id: budget.id,
        uuid: SecureRandom.uuid,
        operator: :+,
        amount: 1,
        description: 'Tet'
      }
    end

    it 'should create a new Transaction' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    it 'should update budget amount' do
      subject
      expect(budget.reload.amount).to eq(Money.new(200))
    end

    include_examples 'valid and not contain errors'

    context 'when parameter are invalid' do
      let(:parameters) { nil }

      include_examples 'not valid and contain errors'
    end
  end
end
