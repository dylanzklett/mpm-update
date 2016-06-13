FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mailinator.com" }
    password 'password'
    password_confirmation { |u| u.password }
    admin false
    after :build do |user, evaluator|
      user.build_profile
    end
    after :create do
      create :setting, :fabric_color
      create :setting, :trough_color
      create :setting, :center_support
      create :setting, :end_bracket
      create :unit_setting, :width_multiplicity
      create :setting, :multiplicity_items
      create :setting, :installation_price
      create :setting, :price_matrix
      create :setting, :trough_step
      create :setting, :trough_matrix
    end
  end

  factory :admin, parent: :user do
    admin true
  end
end
