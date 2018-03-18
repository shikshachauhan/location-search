# All the configuration details are in this file
require "redis"

LOCATION_INDEX = 'locations' #name of the ES index
RADIUS = 500 # Radiua from user location where destination to be searched
REDIS_DB = Redis.new #Redis connection object
TTL_ES_LOCATION = "100d" #Time to invalidate location data stored in Elasticsearch
TTL_REDIS_AUTOCOMPLETE = 86400 # Time to invalidate suggestions cached in redis
ELASTICSEARCH_HOST = "http://127.0.0.1:9200/" # Elasticsearch machine host and port
AUTOCOMPLETE_RESULTS_COUNT = 5 #No of suggestions for a search
GOOGLE_API_KEY = 'AIzaSyDlngXcS9KoGZ81lNo3D67kxgy8oIVrasY'
ES_TIMEOUT = 1
REDIS_TIMEOUT = 1
ES_RECHECK_TIME = 300
CIRCUIT_BREAK_COUNT = 5
GOOGLE_API_TIMEOUT = 4
