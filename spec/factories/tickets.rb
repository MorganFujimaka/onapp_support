FactoryGirl.define do
  factory :ticket do
    customer_name { Faker::Internet.user_name }
    customer_email { Faker::Internet.email }
    subject { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    department
  end
end
