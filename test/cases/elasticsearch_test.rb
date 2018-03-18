require_relative './../test_helper'
require_relative './../../lib/elasticsearch'

describe Elasticsearch do
  before do
    Elasticsearch.create_index('test_index2', {
      "settings" => {
        "number_of_shards" => 1
      }
    })
  end

  describe ".create_index" do
    describe "when passed with index name and properties, creates index" do
      it "should create the index name test_index1" do
        response = Elasticsearch.create_index('test_index1', {
        "settings" => {
          "number_of_shards" => 1
        }})

        uri = URI.parse("#{ELASTICSEARCH_HOST}test_index1?pretty")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)['test_index1'].must_be_instance_of Hash
      end
    end
  end

  describe '.delete_index' do
    describe 'when passed name of the index, it will delete the index' do
      it 'should delete the index with name test_index2' do
        uri = URI.parse("#{ELASTICSEARCH_HOST}test_index2?pretty")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)['test_index2'].must_be_instance_of Hash

        response = Elasticsearch.delete_index('test_index2')
        uri = URI.parse("#{ELASTICSEARCH_HOST}test_index2?pretty")
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)['error'].must_be_instance_of Hash
      end
    end
  end

  describe '.index_document' do
    describe 'when passed with a document with index name, it will index it' do
      it 'should index the passed document' do
        Elasticsearch.create_index('test_index3', {
        "settings" => {
          "number_of_shards" => 1
        }})

        response = Elasticsearch.index_document('test_index3', {
          description: 'new test'
        })

        JSON.parse(response.body)['_shards']['successful'].must_equal 1
      end
    end
  end

  describe '.filter' do
    describe 'when passed with a search query with index name, it will return the search results' do
      it 'should index the passed document' do
        Elasticsearch.create_index('test_index4', {
        "settings" => {
          "number_of_shards" => 1
        }})

        Elasticsearch.index_document('test_index4', {
          description: 'new test'
        })
        sleep(2)
        response = Elasticsearch.filter('test_index4', {})
        JSON.parse(response.body)['hits']['hits'].first['_source']['description'].must_equal 'new test'
      end
    end
  end


  after do
    Elasticsearch.delete_index('test_index1')
    Elasticsearch.delete_index('test_index3')
    Elasticsearch.delete_index('test_index4')
  end

end
