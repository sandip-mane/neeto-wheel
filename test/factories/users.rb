# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { "welcome" }

    trait :admin do
      role { 'super_admin' }
    end

    trait :super_admin do
      role { 'super_admin' }
    end

    trait :owner do
      role { 'owner' }
    end

    trait :secure_password do
      password { generate_password }
    end
  end
end

def generate_password
  Faker::Internet.password(min_length: 10, max_length: 20, mix_case: true, special_characters: true)
end
