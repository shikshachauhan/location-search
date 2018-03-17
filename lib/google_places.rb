require 'net/http'
require 'uri'
require 'json'

class GooglePlaces

  attr_accessor :user_lat, :user_long, :keyword, :locations

  def initialize(user_lat, user_long, keyword)
    self.user_lat = user_lat
    self.user_long = user_long
    self.keyword = keyword
  end

  def self.place_details(place_id)
    uri = URI.parse("https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&key=#{GOOGLE_API_KEY}")
    request = Net::HTTP::Get.new(uri)

    req_options = {
      use_ssl: true
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    data = JSON.parse(response.body)['result']['geometry']
  end


  def load
    uri = google_uri
    request = Net::HTTP::Get.new(uri)

    req_options = {
      use_ssl: uri.scheme == "https"
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    data = JSON.parse response.body
    self.locations = data['predictions']
  end

  def autocomplete_list
    locations.map{|location| location['description']}
  end

  private
    def google_uri
      URI.parse("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{keyword}&location=#{user_lat},#{user_long}&radius=#{RADIUS}&key=#{GOOGLE_API_KEY}")
    end
end
