RSpec.describe Budgets::Create do
  subject { described_class.new(parameters: parameters).call }

  let!(:user) { create(:user) }
  let(:parameters) do
    {
      user_id: user.id,
      uuid: SecureRandom.uuid,
      transactions_attributes: [
        {
          uuid: SecureRandom.uuid,
          operator: :+,
          amount: 2
        },
        {
          uuid: SecureRandom.uuid,
          operator: :-,
          amount: 1
        }
      ]
    }
  end

  describe '.call' do
    it 'should create a new Budget' do
      expect { subject }.to change { Budget.count }.by(1)
    end

    it 'should create Transactions' do
      expect { subject }.to change { Transaction.count }.by(2)
    end

    it 'should calculate budget amount' do
      expect(subject.budget.amount).to eq(Money.new(100))
    end

    include_examples 'valid and not contain errors'

    context 'when parameter are invalid' do
      let(:parameters) { nil }

      include_examples 'not valid and contain errors'
    end
  end
end
