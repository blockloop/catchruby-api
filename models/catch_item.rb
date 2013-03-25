require 'httparty'
require 'ostruct'
require 'json'
require 'awesome_print'

module Catch
  class CatchItem < OpenStruct
    BASEURL = 'https://api.catch.com'

    protected
    def self.get url,options={}
      request :get,url,options
    end

    def self.post url,options={}
      request :post,url,({:body => options})
    end

    private
    def self.request(method,url,options={})
      options.merge!({:basic_auth => Catch.auth})
      # ap "#{method.to_s.upcase}: #{url}"
      # ap "    OPTIONS: #{options}"
      resp = HTTParty.send(method,url,options)
      # ap "#{resp.code}: #{resp.body['status']}"
      json = resp.parsed_response

      unless resp.code == 200 and json["status"].downcase == "ok"
        raise SystemCallError,"Error #{resp.code}: #{resp.body["status"]} Message: #{resp.message}" 
      end
      
      return json['result']
    end
  end
end