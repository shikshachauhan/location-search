require_relative './../test_helper'
require_relative './../../lib/google_places'
describe GooglePlaces do
  describe '.place_details' do
    describe "return the details of a place with a place_id" do
      it 'should return the details of a place' do
        response = GooglePlaces.place_details("ChIJrTLr-GyuEmsRBfy61i59si0")
        response['location']['lat'].must_equal -33.867591
        response['location']['lng'].must_equal 151.201196
      end
    end
    describe "#load" do
      it 'should load locations and autocomplet list' do
        response = GooglePlaces.new(21, 76, "moti nagar")
        response.load
        (response.locations.length > 0).must_equal true
        (response.autocomplete_list.include?("Moti Nagar, New Delhi, Delhi, India")).must_equal true
      end
    end
  end
end
