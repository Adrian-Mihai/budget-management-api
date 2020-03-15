describe Users::Create do
  subject { described_class.new(parameters: parameters).call }

  describe '.call' do
    let(:parameters) do
      {
        uuid: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.safe_email,
        password: '123456789',
        password_confirmation: '123456789'
      }
    end

    it 'should create a new user' do
      expect { subject }.to change { User.count }.by(1)
    end

    include_examples 'valid and not contain errors'

    context 'when parameter are invalid' do
      let(:parameters) { nil }

      include_examples 'not valid and contain errors'
    end
  end
end
