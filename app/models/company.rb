# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_lower_name  (lower((name)::text)) UNIQUE
#  index_companies_on_name        (name) UNIQUE
#
class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :flights, dependent: :destroy
end
