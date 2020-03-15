FactoryBot.define do
  factory :budget do
    association :user, factory: :user
    uuid { SecureRandom.uuid }
  end
end
