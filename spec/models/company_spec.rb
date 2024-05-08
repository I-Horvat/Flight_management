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
RSpec.describe Company, type: :model do
  let(:company) { build(:company) }

  it 'is not valid without a name' do
    company.name = nil
    expect(company).not_to be_valid
  end

  it 'is not valid with a duplicate (case-insensitive) name' do
    create(:company, name: 'Example Company')
    company.name = 'EXAMPLE company'
    expect(company).not_to be_valid
  end
end
