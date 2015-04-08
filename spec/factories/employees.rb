FactoryGirl.define do
  factory :employee do
    association :department, factory: :department
  end
end
