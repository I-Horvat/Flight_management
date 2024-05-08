# frozen_string_literal: true

require_relative '../../../app/domains/open_weather_map/city'
require_relative '../../../app/domains/open_weather_map/resolver'

describe OpenWeatherMap::Resolver do
  describe '.city_id' do
    let(:city_name) { 'Qabāghlū'.dup }
    let(:fake_city_name) { 'blablagrad'.dup }

    context 'when called with a known city name' do
      it 'returns the correct id' do
        expect(described_class.city_id(city_name)).to eq(3530)
      end
    end

    context 'when called with an unknown city name' do
      it 'returns nil' do
        expect(described_class.city_id(fake_city_name)).to be_nil
      end
    end
  end
end
