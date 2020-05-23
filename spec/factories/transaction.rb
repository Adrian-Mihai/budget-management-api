FactoryBot.define do
  factory :transaction do
    association :user, factory: :user
    uuid { SecureRandom.uuid }
    operator { %w[+ -].sample }
  end
end
