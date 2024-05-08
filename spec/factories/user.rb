FactoryBot.define do
  sequence :user_first_name do |n|
    "John#{n}"
  end

  sequence :user_email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    first_name { generate(:user_first_name) }
    email { generate(:user_email) }
    last_name { 'test2' }
    password { '123' }
    role { 'admin' }
  end
end
