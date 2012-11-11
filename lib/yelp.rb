require 'rubygems'
require 'oauth'
require 'json'
require 'app_config'

module Yelp
  mattr_accessor :consumer, :access_token

  self.consumer = OAuth::Consumer.new(AppConfig::yelp_consumer_key, AppConfig::yelp_consumer_secret,
                                      {:site => "http://#{AppConfig::yelp_api_host}"})
  self.access_token = OAuth::AccessToken.new(consumer, AppConfig::yelp_token, AppConfig::yelp_token_secret)

  module Request
    def self.geopoint(latitude, longitude)
      return "/v2/search?ll=#{latitude},#{longitude}"
    end
    
    def self.location(params)
#      params = {:location => nil,
#                :category_filter => "restaurants",
#                :radius_filter => 1,
#                :limit => nil,
#                :term => nil,
#                :latitude => nil,
#                :longitude => nil,
#                :location => nil}.merge(params)
#      params[:location] = URI::encode(params[:location].gsub(/\s+/, '+')) unless params[:location].nil?
      params[:cll] = "#{params[:latitude]},#{params[:longitude]}" unless params[:latitude].nil? or params[:longitude].nil?
      params[:latitude] = params[:longitude] = nil
      params.delete_if{ |k,v| v.nil? }
      return "/v2/search?#{params.to_query}"
    end

    def self.id(id)
      return "/v2/business/#{id}"
    end

  end

  class Response
    attr_accessor :response, :businesses

    def initialize(response)
      @response = response
      @businesses = @response['businesses'] if count > 0
    end

    def count
      if @response.has_key?('error') or @response.nil?
        Rails.logger.error "A search query has not been submitted yet"  if @response.nil?
        Rails.logger.error "Error: #{response['error']['text']}"        if @response.has_key?('error')
        return 0
      end
      return response['total'].to_i
    end

    def get_first_result
      return @businesses.first unless @businesses.nil?
    end

    def self.get_last_result
      return get_result(@response, @businesses[count-1]) unless @businesses.nil?
    end

    def self.get_nth_result(n)
      return get_result(@response, n-1) unless @businesses.nil?
    end

    private
      # returns the nth result. If n is too large, the last result will be returned
      def self.get_result(n=1)
        return if @response.nil?
        index = [n, result_count(@response)].min-1
        return response['businesses'][index]
      end
  end

  class Search
    attr_accessor :query, :response, :businesses

    def initialize(query = nil)
      @query = query.strip
    end

    def request
      Rails.logger.info "Yelp query is #{query}"
      Rails.logger.info "Fetching Yelp data.."
      Response.new(JSON.parse(Yelp.access_token.get(@query).body))
    end
  end

end
