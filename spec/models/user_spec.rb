RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:transactions) }
  end

  describe 'validations' do
    subject { create(:user) }

    it { should validate_presence_of(:uuid) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:password).is_at_least(8) }

    context 'email' do
      it { should allow_value(subject.email).for(:email) }
      it { should_not allow_value('email.example').for(:email) }
    end
  end

  describe '#username' do
    let(:name) { Faker::Name.name }
    let!(:user) { create(:user, name: name) }

    it 'should return the name' do
      expect(user.username).to eq(name)
    end

    context 'when name do not exist' do
      let(:email) { Faker::Internet.safe_email }
      let!(:user) { create(:user, name: nil, email: email) }

      it 'should return the parsed email' do
        expect(user.username).to eq(user.email.split('@').first)
      end
    end
  end
end
