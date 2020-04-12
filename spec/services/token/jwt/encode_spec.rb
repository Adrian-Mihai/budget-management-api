describe Token::Jwt::Encode do
  subject { described_class.call(user_uuid: uuid, user_email: email) }

  let(:uuid) { SecureRandom.uuid }
  let(:email) { Faker::Internet.safe_email }
  let(:payload) { { user_uuid: uuid, user_email: email, exp: expiration } }
  let(:expiration) { Integer(Time.current + 30.minutes) }

  before do
    Timecop.freeze(Time.current)
  end

  after do
    Timecop.return
  end

  before do
    allow(Rails.application.credentials).to receive(:secret_key_base).and_return('mock-key')
    allow(JWT).to receive(:encode).with(payload, 'mock-key').and_return('mock-token')
  end

  context 'when token life time env is set' do
    before { stub_env('JWT_TOKEN_LIFE_TIME', 30) }

    it 'should use the token life time env variable' do
      expect(subject).to eq(token: 'mock-token', expiration: 1800)
    end
  end

  context 'when token life time env variable is not set' do
    let(:expiration) { Integer(Time.current + 60.minutes) }

    it 'should use the the default value' do
      expect(subject).to eq(token: 'mock-token', expiration: 3600)
    end
  end
end
