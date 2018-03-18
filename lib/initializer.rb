require_relative './elasticsearch'
require_relative './constants'

Elasticsearch.create_index(LOCATION_INDEX, {
  "settings" => {
    "number_of_shards" => 1
  },
  "mappings" => {
    "default" => {
      "_ttl" => {
        "enabled" => true,
        "default" => TTL_ES_LOCATION
      },
      "properties" => {
        "description" => {
          "type" => "string",
          "analyzer" => "simple"
        },
        "location" => {
          "type" => "geo_point"
        }
      }
    }
  }
})

REDIS_DB.keys('*cached_res:*').each do |key| REDIS_DB.del(key) end
