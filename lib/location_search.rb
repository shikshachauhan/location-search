require 'json'
require 'timeout'
require_relative './google_places'
require_relative './elasticsearch_places'
require_relative './constants'
require_relative './search_service_interface'

class LocationSearch

  attr_accessor :user_lat, :user_long, :keyword, :cache_key, :autocomplete_list, :es_results, :google_results

  def initialize(user_lat, user_long, keyword)
    self.user_lat = user_lat
    self.user_long = user_long
    self.keyword = keyword
    self.cache_key = "cached_res:#{[user_lat, user_long, keyword].to_json}"
  end

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
      es_inactive = REDIS_DB.get(:es_inactive).to_i
      begin
        if es_inactive < CIRCUIT_BREAK_COUNT #This will break the circuit if ES is down and fall back to Google api
          Timeout::timeout(ES_TIMEOUT) do
            self.es_results = ElasticsearchPlaces.new(user_lat, user_long, keyword)
            es_results.load
            if es_results.locations.count == AUTOCOMPLETE_RESULTS_COUNT
              self.autocomplete_list = es_results.autocomplete_list
              update_cache
              return true
            end
            false
          end

        else
          raise "ES not working"
        end
      rescue => e
        if e.class == Timeout::Error
          if es_inactive.zero?
            REDIS_DB.set(:es_inactive, 1, ex: ES_RECHECK_TIME)# After ES_RECHECK_TIME, it will again check if ES started working
          else
            REDIS_DB.set(:es_inactive, es_inactive + 1)
          end
        end
      end

    end

    # looks for suggestions from google places api
    def load_from_google_places_if_exists?
      Timeout::timeout(GOOGLE_API_TIMEOUT) do
        self.google_results = GooglePlaces.new(user_lat, user_long, keyword)
        google_results.load
      end
      es_results.update_in_background(google_results)
      self.autocomplete_list = google_results.autocomplete_list
      update_cache
    end
    
end
