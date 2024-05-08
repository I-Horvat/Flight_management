# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    email { 'marko@email.com' }
    password { '123' }
  end
end
