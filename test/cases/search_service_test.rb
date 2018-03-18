require_relative './../test_helper'
require_relative './../../lib/search_service'

describe SearchService do
  describe '#search_location' do
    describe "when no results found" do
      it 'must provide no result' do
        response = SearchService.new.search_location(21, 76, "test destination")
        response.must_equal "No Results found"
      end
    end
    describe "results are found" do
      it 'must provide search result corresponding to test destination' do
        response = SearchService.new.search_location(21, 76, "moti nagar")
        (response.length > 0).must_equal true
        (response.include?("Moti Nagar, New Delhi, Delhi, India")).must_equal true
      end
    end
  end
end
