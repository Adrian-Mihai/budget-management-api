RSpec.describe Budget, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:transactions) }
    it { should have_db_index(:user_id).unique }
  end

  describe 'validates' do
    subject { create(:budget) }

    it { should validate_presence_of(:uuid) }
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_uniqueness_of(:user_id) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:amount) }
  end
end
