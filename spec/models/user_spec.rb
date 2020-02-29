RSpec.describe User, type: :model do
  describe 'validations' do
    subject { FactoryBot.create(:user) }

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
end
