FactoryGirl.define do
  factory :item do
    sequence(:name){ |n| "item#{n}" }
    quantity 1
    price 1
  end
end
