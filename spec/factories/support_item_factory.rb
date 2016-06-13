FactoryGirl.define do
  factory :support_item do
    sequence(:name){ |n| "support_item#{n}" }
    quantity 1
  end
end
