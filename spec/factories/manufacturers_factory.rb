FactoryGirl.define do
  factory :manufacturer do
    sequence(:email) { |n| "manufacturer#{n}@mailinator.com" }
    sequence(:title) { |n| "Title #{n}" }
    manufacturer_type :drape
  end
end
