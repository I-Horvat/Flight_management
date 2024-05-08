module OpenWeatherMap
  class City
    include Comparable
    attr_accessor :id, :lat, :lon, :name, :temp_k

    def initialize(id:, lat:, lon:, name:, temp_k:)
      @id = id
      @lat = lat
      @lon = lon
      @name = name
      @temp_k = temp_k
    end

    def temp
      (@temp_k - 273.15).round(2)
    end

    def <=>(other)
      [temp_k, name] <=> [other.temp_k, other.name]
    end

    def self.parse(city_response)
      City.new(
        id: city_response['id'].to_i,
        lat: city_response['coord']['lat'].to_f,
        lon: city_response['coord']['lon'].to_f,
        name: city_response['name'],
        temp_k: city_response['main']['temp'].to_f
      )
    end

    def nearby(count = 5)
      return [] unless lat && lon

      response = HTTP.get(BASE_PATH + "find?lat=#{lat}&lon=#{lon}&cnt=#{count}&appid=#{API_KEY}")
      data = JSON.parse(response)

      data['list'].map { |city_data| City.parse(city_data) }.sort
    end

    def coldest_nearby(count = 5)
      nearby(count).min
    end
  end
end
