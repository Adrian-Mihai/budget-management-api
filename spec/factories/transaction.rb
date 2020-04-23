FactoryBot.define do
  factory :transaction do
    association :user, factory: :user
    uuid { SecureRandom.uuid }
    operator { %w[+ -].sample }
    creation_date { Time.zone.now }
  end
end
