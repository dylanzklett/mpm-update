FactoryGirl.define do
  factory :setting do
    trait :fabric_color do
      code 'fabric_color'
      value 'Red, Green, Blue'
    end
    trait :trough_color do
      code 'trough_color'
      value 'Red, Green, Blue'
    end
    trait :center_support do
      code 'center_support'
      value '2, 4, 6'
    end
    trait :end_bracket do
      code 'end_bracket'
      value '2, 4, 6'
    end
   trait :multiplicity_items do
      code 'multiplicity_items'
      value '[]'
    end
    trait :installation_price do
      code 'installation_price'
      value '25'
    end
    trait :price_matrix do
      code 'price_matrix'
      value '{"1,1":"100.02","2,1":"200.01","3,3":"300,01","10,10":"400,01"}'
    end
    trait :trough_step do
      code 'trough_step'
      value '15, 25, 45, 80, 150, 230'
    end
    trait :trough_matrix do
      code 'trough_matrix'
      value '{"1,1":"A9-15","2,1":"B10-15","2,2":"B9-15"}'
    end
  end

  factory :unit_setting do
    trait :width_multiplicity do
      code 'width_multiplicity'
      value '20 in'
      type 'UnitSetting'
    end
  end
end
