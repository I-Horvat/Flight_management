# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id           (company_id)
#  index_flights_on_name_and_company_id  (name,company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
RSpec.describe Flight, type: :model do
  let(:company) { build(:company) }
  let(:flight) { build(:flight, company: company) }

  it { is_expected.to belong_to(:company) }

  it 'is valid with valid attributes' do
    expect(flight).to be_valid
  end

  it 'is not valid without a name' do
    flight.name = nil
    expect(flight).not_to be_valid
  end

  it 'is not valid without a valid departure time' do
    flight.departs_at = nil
    expect(flight).not_to be_valid
  end

  it 'is not valid without a valid arrival time' do
    flight.arrives_at = nil
    expect(flight).not_to be_valid
  end

  it 'is not valid if departure time is after arrival time' do
    flight.departs_at = Time.zone.now + 2.days
    flight.arrives_at = Time.zone.now + 1.day
    expect(flight).not_to be_valid
  end

  it 'is not valid without a valid base price' do
    flight.base_price = 0
    expect(flight).not_to be_valid
  end

  it 'is not valid without a valid number of seats' do
    flight.no_of_seats = 0
    expect(flight).not_to be_valid
  end
end
