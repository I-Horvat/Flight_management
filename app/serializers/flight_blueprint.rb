class FlightBlueprint < Blueprinter::Base
  identifier :id

  view :default do
    field :name
    field :no_of_seats, integer: true
    field :base_price, integer: true
    field :departs_at
    field :arrives_at
    field :created_at
    field :updated_at
    association :company, blueprint: CompanyBlueprint
  end
end
