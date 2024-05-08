# frozen_string_literal: true

require 'http'
require 'rails'

module OpenWeatherMap
  API_KEY = Rails.application.credentials.open_weather_map_api_key
  BASE_PATH = 'https://api.openweathermap.org/data/2.5/'

  def self.city(name)
    town_id = OpenWeatherMap::Resolver.city_id(name)
    return if town_id.nil?

    response = HTTP.get(BASE_PATH + "weather?id=#{town_id}&appid=#{API_KEY}")
    data = JSON.parse(response)
    return if data.nil?

    OpenWeatherMap::City.parse(data)
  end

  def self.cities(cities)
    city_ids = cities.reject(&:empty?)
                     .map { |city| OpenWeatherMap::Resolver.city_id(city) }
                     .compact
                     .join(',')
    return [] if city_ids.empty?

    response = HTTP.get(BASE_PATH + "group?appid=#{API_KEY}&id=#{city_ids}")
    data = JSON.parse(response)
    data['list'].map { |city_response| OpenWeatherMap::City.parse(city_response) }
  end
end
