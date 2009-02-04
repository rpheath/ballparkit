require 'net/http'
require 'uri'

module Ballpark
  class UrlShortener
    attr_accessor :estimate, :host, :options
    
  private
    # the public URL to shorten
    def longurl
      URI.parse("http://#{host}/estimate/#{estimate.token}")
    end
    
    # the request URL
    def url
      @url ||= URI.parse("http://is.gd/api.php?longurl=#{longurl}")
    end
  
  public
    def initialize(estimate, host, options = {})
      @estimate, @host, @options = estimate, host, options
    end
    
    # process the actual request to http://is.gd and
    # save the shortened url for that estimate
    def process
      return unless Rails.env.production? || options[:force]
      
      response = Net::HTTP.new(url.host, url.port).start do |http|
        http.get([url.path, url.query].join('?'))
      end
      
      estimate.short_url = response.body.to_s
      estimate.save(false)
      
    rescue Exception => e
      logger.error(e.message)
    end
  end
end