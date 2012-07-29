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
      params = {:location => nil,
                :category_filter => "restaurants",
                :radius_filter => 1,
                :limit => nil,
                :term => nil,
                :latitude => nil,
                :longitude => nil,
                :location => nil}.merge(params)
      #params[:location] = URI::encode(params[:location].gsub(/\s+/, '+')) unless params[:location].nil?
      params[:cll] = "#{params[:latitude]},#{params[:longitude]}" unless params[:latitude].nil? or params[:longitude].nil?
      params[:latitude] = params[:longitude] = nil
      params.delete_if{ |k,v| v.nil? }
      return "/v2/search?#{params.to_query}"
    end

    def self.id(id)
      return "/v2/business/#{id}"
    end

  end

  module Business
    def self.retrieve(query)
      Rails.logger.info "Yelp query is #{query}"
      Rails.logger.info "Fetching Yelp data.."
      JSON.parse(Yelp.access_token.get(query).body)
    end

    def self.result_count(response)
      if response.has_key?('error')
        Rails.logger.error "Error: #{response['error']['text']}"
        return -1
      end
      return response['total'].to_i if response.has_key?('total')
      return 1
    end

    # returns the nth result. If n is too large, the last result will be returned
    def self.get_result(response, n=1)
      return if result_count(response) < 1
      return response unless response.has_key?('businesses')

      max_index = [n, result_count(response)].max-1
      return response['businesses'][max_index]
    end

    def self.info(response, n=1)
      result = get_result(response, n)
      return if result.nil?
      # based on http://www.yelp.com/developers/documentation/v2/search_api
      {:name           => result['name'],
       :identifier     => result['id'],
       :rating_img_url => result['rating_img_url'],
       :review_count   => result['review_count'],
       :mobile_url     => result['mobile_url'],
       :url            => result['url'],
       :image_url      => result['image_url'],
      }
    end

    def self.fetch_info(query, n=1)
      info(retrieve(query),n)
    end
  end

end
