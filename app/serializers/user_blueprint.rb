require 'blueprinter'

class UserBlueprint < Blueprinter::Base
  identifier :id
  field :first_name do |user|
    user.first_name.capitalize
  end
  field :last_name do |user|
    user.last_name.capitalize
  end
  field :email
  field :created_at
  field :updated_at
  field :role
end
