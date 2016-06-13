FactoryGirl.define do
  factory :profile do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name) { |n| "second_name#{n}" }
    sequence(:city) { |n| "city#{n}" }
    phone_o '0123456789'
  end
end
