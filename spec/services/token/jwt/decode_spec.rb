describe Token::Jwt::Decode do
  subject { described_class.call(token: token) }

  let(:token) { 'mock-token' }
  let(:payload) { { user_email: Faker::Internet.safe_email, user_uuid: SecureRandom.uuid } }

  before do
    allow(Rails.application.secrets).to receive(:secret_key_base).and_return('mock-key')
    allow(JWT).to receive(:decode).with(token, 'mock-key').and_return([payload])
  end

  it 'should decode the token' do
    expect(subject.symbolize_keys).to eq(payload)
  end
end
