require 'json'

require_relative 'city'

module OpenWeatherMap
  module Resolver
    def self.city_id(name)
      json_file_path = File.expand_path('city_ids.json', __dir__)
      return unless File.exist?(json_file_path)

      json_data = JSON.parse(File.read(json_file_path, encoding: 'UTF-8'))
      city_entry = json_data.find { |entry| entry['name'] == name }

      city_entry['id'] if city_entry
    end
  end
end
