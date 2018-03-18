require_relative './../test_helper'
require_relative './../../lib/location_search'
describe LocationSearch do

  describe "#load" do
    it 'should load locations and autocomplet list' do
      response = LocationSearch.new(21, 76, "moti nagar")
      response.load
      (response.autocomplete_list.include?("Moti Nagar, New Delhi, Delhi, India")).must_equal true
    end
  end

end
