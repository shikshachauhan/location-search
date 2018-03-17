require 'json'
require_relative './google_places'
require_relative './elasticsearch_places'
require_relative './constants'

class LocationSearch

  attr_accessor :user_lat, :user_long, :keyword, :cache_key, :autocomplete_list, :es_results, :google_results

  def initialize(user_lat, user_long, keyword)
    self.user_lat = user_lat
    self.user_long = user_long
    self.keyword = keyword
    self.cache_key = "cached_res:#{[user_lat, user_long, keyword].to_json}"
  end

  # Task 1 - This is calling up the search service
  def load
    load_from_cache_if_exists? || load_from_es_places_if_exist? || load_from_google_places_if_exists?
  end

  private
    # Task 3 - Caching Layer. It looks for suggestions from redis
    def load_from_cache_if_exists?
      self.autocomplete_list = JSON.parse(REDIS_DB.get(cache_key)) if REDIS_DB.get(cache_key)
      autocomplete_list && !autocomplete_list.empty?
    end

    def update_cache
      REDIS_DB.set(cache_key, autocomplete_list, ex: TTL_REDIS_AUTOCOMPLETE)
    end

    # looks for suggestions from elasticsearch
    def load_from_es_places_if_exist?
      self.es_results = ElasticsearchPlaces.new(user_lat, user_long, keyword)
      es_results.load
      if es_results.locations.count == AUTOCOMPLETE_RESULTS_COUNT
        self.autocomplete_list = es_results.autocomplete_list
        update_cache
        return true
      end
      false
    end

    # looks for suggestions from google places api
    def load_from_google_places_if_exists?
      self.google_results = GooglePlaces.new(user_lat, user_long, keyword)
      google_results.load
      es_results.update_in_background(google_results)
      self.autocomplete_list = google_results.autocomplete_list
      update_cache
    end

end
