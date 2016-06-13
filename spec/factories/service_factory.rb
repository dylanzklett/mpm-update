FactoryGirl.define do
  factory :service do
    sequence(:name) { |n| "service #{n} generated" }
    price { rand(1.0..100.0).round(3) }
  end
end
