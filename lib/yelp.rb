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
    def self.retrieve(query)
      puts "Yelp query is #{query}"
      JSON.parse(Yelp.access_token.get(query).body)
    end

    def self.result_count(response)
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
