# frozen_string_literal: true

FactoryBot.define do
  factory :note do
    title { "Buy milk" }
    description { "Buy 1 liter milk from grocery store" }
    association :user, factory: :user

    trait :rent do
      title { "Pay rent" }
      description { "Transfer $500 to landlord by Monday" }
    end

    trait :bulbs do
      title { "Fix bulbs" }
      description { "Change the lighbulbs in the foyer" }
    end
  end
end