require_relative './../test_helper'
require_relative './../../lib/elasticsearch_places'
require_relative './../../lib/search_service'

describe ElasticsearchPlaces do

  before do
    response = ElasticsearchPlaces.new(21, 76, "bla bla")
    response.load
    sleep(2)
    @google_places = GooglePlaces.new(21, 76, "moti nagar")
    @google_places.load
    response.update(@google_places)

    sleep(2)
  end

  describe '#update' do
    it 'indexes google places response in es' do
      response = ElasticsearchPlaces.new(21, 76, "manhatten")
      response.load
      sleep(2)
      google_places = GooglePlaces.new(21, 76, "manhatten")
      google_places.load
      search = Elasticsearch.filter(LOCATION_INDEX, {
        "query" => {
          "match" => {
            "description" => {
              "query" => google_places.autocomplete_list.first,
              "fuzziness" => 2,
              "operator" => "AND"
            }
          }
        }
      })
      (JSON.parse(search.body)['hits']['total'] == 0).must_equal true

      response.update(google_places)
      sleep(2)

      search = Elasticsearch.filter(LOCATION_INDEX, {
        "query" => {
          "match" => {
            "description" => {
              "query" => google_places.autocomplete_list.first,
              "fuzziness" => 2,
              "operator" => "AND"
            }
          }
        }
      })
      (JSON.parse(search.body)['hits']['total'] == 0).must_equal false
    end
  end

  describe '#load' do
    it 'should load locations and autocomplet list' do
      response = ElasticsearchPlaces.new(21, 76, "moti nagar")
      response.load
      (response.locations.length > 0).must_equal true
    end
  end

end
