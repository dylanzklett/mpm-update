FactoryGirl.define do
  factory :task do
    date_wanted Date.current + 1.day
    status 'open'
  end

  factory :drape_task, parent: :task, class: 'DrapeTask'
  factory :trough_task, parent: :task, class: 'TroughTask'
end
