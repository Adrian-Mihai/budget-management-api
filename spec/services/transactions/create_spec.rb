RSpec.describe Transactions::Create do
  subject { described_class.new(parameters: parameters).call }

  describe '.call' do
    let!(:user) { create(:user) }
    let(:parameters) do
      {
        uuid: SecureRandom.uuid,
        user_id: user.id,
        operator: :+,
        amount: 1,
        description: 'Test'
      }
    end

    it 'should create a new Transaction' do
      expect { subject }.to change { Transaction.count }.by(1)
    end

    include_examples 'valid and not contain errors'

    context 'when parameter are invalid' do
      let(:parameters) { nil }

      include_examples 'not valid and contain errors'
    end
  end
end
