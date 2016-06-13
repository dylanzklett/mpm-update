FactoryGirl.define do
  factory :inventory_item do
    sequence(:name){ |n| "inventory_item#{n}" }
    sequence(:unit){ |n| "unit#{n}" }
    amount 1
  end

  factory :inventory_history_item do
    inventory_item
    event 'addition'
    amount 1
  end
end
