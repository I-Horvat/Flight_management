FactoryBot.define do
  factory :booking do
    seat_price { 50 }
    no_of_seats { 2 }
    association :flight, factory: :flight
    association :user, factory: :user
  end
end
