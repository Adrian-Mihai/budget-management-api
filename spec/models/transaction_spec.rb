RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:budget) }
    it { should have_db_index(:budget_id) }
  end

  describe 'validation' do
    subject { create(:transaction) }

    it { should validate_presence_of(:uuid) }
    it { should validate_uniqueness_of(:uuid) }
    it { should validate_presence_of(:pay_day) }
    it { should validate_presence_of(:operator) }
    it { should validate_inclusion_of(:operator).in_array(%w[+ -]) }
  end

  describe 'monetize' do
    it { is_expected.to monetize(:amount) }
  end
end
