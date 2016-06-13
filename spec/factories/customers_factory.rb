FactoryGirl.define do
  factory :customer do
    sequence(:email) { |n| "customer#{n}@mailinator.com" }

    trait :with_profile do
      profile

      transient do
        profile_attributes nil
      end

      after :build do |customer, evaluator|
        evaluator.profile_attributes && customer.profile.assign_attributes(evaluator.profile_attributes)
      end
    end
  end
end
