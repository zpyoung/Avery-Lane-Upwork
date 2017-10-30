FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end
  
  factory :user do
    first_name "John"
    last_name "Doe"
    email
    password "password"
  end
end