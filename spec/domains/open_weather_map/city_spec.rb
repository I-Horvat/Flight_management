require_relative '../../../app/domains/open_weather_map/city'

describe OpenWeatherMap::City do
  let(:city) do
    described_class.new(
      id: 834,
      name: 'Ḩeşār-e Abīk',
      lon: 47.159401,
      lat: 34.330502,
      temp_k: 300
    )
  end

  let(:city4) do
    described_class.new(
      id: 833,
      name: 'blab',
      lon: 47.159401,
      lat: 34.330502,
      temp_k: 123
    )
  end
  let(:city3) do
    described_class.new(
      id: 833,
      name: 'Ḩeşār-e Sefīd',
      lon: 47.159401,
      lat: 34.330502,
      temp_k: 500
    )
  end
  let(:city2) do
    described_class.new(
      id: 833,
      name: 'Ḩeşār-e Sefīd',
      lon: 47.159401,
      lat: 34.330502,
      temp_k: 123
    )
  end

  context 'when calling new with valid city response' do
    it 'returns the new object' do
      expect(city.id).to eq(834)
      expect(city.lat).to eq(34.330502)
      expect(city.lon).to eq(47.159401)
      expect(city.name).to eq('Ḩeşār-e Abīk')
      expect(city.temp_k).to eq(300)
    end
  end

  describe '#temp' do
    it 'converts temperature correctly from Kelvins to Celsius' do
      expect(city.temp).to eq((300 - 273.15).round(2))
    end
  end

  context 'when compare objects' do
    it 'order objects' do
      expect([city, city2, city3, city4].sort).to eql([city4, city2, city, city3])
    end
  end
end
