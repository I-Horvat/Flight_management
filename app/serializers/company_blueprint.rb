# frozen_string_literal: true

class CompanyBlueprint < Blueprinter::Base
  identifier :id
  field :name
  field :created_at
  field :updated_at
end
