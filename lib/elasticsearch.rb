require 'net/http'
require 'uri'
require 'json'
require_relative './constants'

class Elasticsearch

  def self.create_index(name, properties)
    delete_index(name)
    uri = URI.parse("#{ELASTICSEARCH_HOST}#{name}")
    request = Net::HTTP::Post.new(uri)
    request.body = JSON.dump(properties)

    req_options = {
      use_ssl: false,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def self.delete_index(name)
    uri = URI.parse("#{ELASTICSEARCH_HOST}#{name}")
    request = Net::HTTP::Delete.new(uri)

    req_options = {
      use_ssl: false,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def self.index_document(name, document)
    uri = URI.parse("#{ELASTICSEARCH_HOST}#{name}/default")
    request = Net::HTTP::Post.new(uri)
    request.body = JSON.dump(document)

    req_options = {
      use_ssl: false,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

  def self.filter(name, query)
    uri = URI.parse("#{ELASTICSEARCH_HOST}#{name}/_search")
    request = Net::HTTP::Get.new(uri)
    request.body = JSON.dump(query)

    req_options = {
      use_ssl: false,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

end
