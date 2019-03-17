require 'json'
require 'net/http'
require 'uri'

mbt = 'pk.eyJ1IjoibWF0dGgiLCJhIjoiY2pxaWI0azRmMHVsdDN5bDJrYnpjdGo2dSJ9.FDKb_aKILLXV4uJCi6Zyug'
endpoint = 'https://api.mapbox.com/geocoding/v5/mapbox.places/'


namespace :geocode do
  task :buildings, [:base_path] => :environment do |_, args|
    Building.all.each do |building|
      next if building.lat
      url = "#{endpoint}#{URI.encode(building.address)}.json?limit=1&access_token=#{mbt}"
      puts "Trying #{url}"

      uri = URI(url)
      response = Net::HTTP.get(uri)
      result = JSON.parse(response)
      # puts result

      features = result['features']
      next unless features
      next if features.length < 0
      first = features[0]['center']

      type = features[0]['place_type'][0]
      puts "skipping, type is #{type}" if type != 'address'
      next if type != 'address'

      building.lng = first[0]
      building.lat = first[1]
      puts building.save
      puts "Saved #{building.name}"
    end
  end

  task :correct, [:base_path] => :environment do |_, args|
    Building.all.each do |building|

      # Good lng: -83.045753
      next unless building.lat < 39

      lat = building.lng
      lng = building.lat
      building.lat = lat
      building.lng = lng
      puts building.save
      puts "Saved #{building.name}"
    end
  end
end
