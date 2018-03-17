require_relative './elasticsearch'
require_relative './constants'

class ElasticsearchPlaces
  attr_accessor :user_lat, :user_long, :keyword, :locations
  def initialize(user_lat, user_long, keyword)
    self.user_lat = user_lat
    self.user_long = user_long
    self.keyword = keyword
  end

  # Task 2 - an async broadcast of
  # the Request-Response to all the classes that have registered, without putting user in a waiting
  # state.
  def update_in_background(google_results)
    job = fork do
      update(google_results)
    end
    Process.detach(job)
  end

  def update(google_results)
    descriptions = autocomplete_list
    google_results.locations.each do |google_location|
      unless (descriptions.include?(google_location['description']))
        place_details = GooglePlaces.place_details(google_location['place_id'])
        Elasticsearch.index_document(LOCATION_INDEX, {
          "description" => google_location['description'],
          "location" => {
            "lat" => place_details['location']['lat'],
            "lon" => place_details['location']['lng']
          }
        })
      end
    end
  end

  def load
    result = Elasticsearch.filter(LOCATION_INDEX, {
      'from' => 0,
      'size' => 5,
      "query" => {
        "match" => {
          "description" => {
            "query" => keyword,
            "fuzziness" => 2,
            "operator" => "AND"
          }
        }
      },
      # Task 4 - Users coordinates are being used as a pin location
      #, and we are trying to find the destination in a radius around the location
      "filter" => {
        "geo_distance" => {
          "distance" => "#{RADIUS}km",
          "location" => {
            "lat" => user_lat,
            "lon" => user_long
          }
        }
      }
    })
    self.locations = JSON.parse(result.body)['hits']['hits'].map{|record| record['_source']}
  end

  def autocomplete_list
    locations.map{|location| location['description']}
  end
end
