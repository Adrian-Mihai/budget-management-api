FactoryBot.define do
  factory :transaction do
    association :budget, factory: :budget
    uuid { SecureRandom.uuid }
    operator { %w[+ -].sample }
  end
end
