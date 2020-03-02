FactoryBot.define do
  factory :user do
    uuid     { SecureRandom.uuid }
    email    { Faker::Internet.safe_email }
    name     { Faker::Name.name }
    password { Faker::Internet.password(min_length: 8) }
  end
end
