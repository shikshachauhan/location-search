require_relative './location_search'

class SearchService

  include SearchServiceInterface

  # Task 1 - This is calling up the search service
  def search_location(user_lat, user_long, keyword)
    begin
      location_search = LocationSearch.new(user_lat, user_long, keyword)
      location_search.load
      if location_search.autocomplete_list.empty?
        "No Results found"
      else
        location_search.autocomplete_list
      end
    rescue => e
      "Something went Wrong !! #{e.inspect}"
    end
  end
end
