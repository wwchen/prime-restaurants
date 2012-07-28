require 'rubygems'
require 'oauth'
require 'json'

module Yelp
  mattr_accessor :consumer_key, :consumer_secret, :token, :token_secret, :api_host
  mattr_accessor :consumer, :access_token
  consumer_key = 'thFnLxyA-GO_aFdPGlM_Xg'
  consumer_secret = 'kbBbIk53rPb99YppF3Q7H9vtlxc'
  token = 'XkDhYHxCfqa8UK7n2koGwZ-wnM_F_Ptb'
  token_secret = 'fcWuQPwQgEww8k-zyQ5Y27P7O8I'
  api_host = 'api.yelp.com'

  self.consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
  self.access_token = OAuth::AccessToken.new(consumer, token, token_secret)

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
      params.delete_if{ |k,v| v.nil? }
      return "/v2/search?#{params.to_query}"
    end

#    def self.location(location, term = nil, category_filter = "restaurants", latitude = nil, longitude = nil)
#      cll_param = "&cll=#{latitude},#{longitude}" unless latitude.nil? or longitude.nil?
#      return "/v2/search?location=#{location}&term=#{URI::encode(term)}#{cll_param}"
#    end

    def self.id(id)
      return "/v2/business/#{id}"
    end

  end

  module Business
    def self.result_count(response)
      return response['total'].to_i if response.has_key?('total')
      return 1
    end

    def self.retrieve(query)
      puts "Yelp query is #{query}"
      JSON.parse(Yelp.access_token.get(query).body)
    end

    def self.review_count(response)
      return if result_count(response) < 1
      response = response['businesses'][0] if response.has_key?('businesses')
      response['review_count']
    end

    def self.name(response)
    end
  end

end
