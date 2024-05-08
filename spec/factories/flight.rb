FactoryBot.define do
  sequence :flight_name do |n|
    "Flight #{n}"
  end

  factory :flight do
    name { generate(:flight_name) }
    departs_at { Time.zone.now + 1.day }
    arrives_at { Time.zone.now + 2.days }
    base_price { 100 }
    no_of_seats { 150 }
    company
  end
end
