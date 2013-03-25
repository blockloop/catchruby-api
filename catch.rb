# Copyright 2011 Catch.com, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

=begin usage
 require 'catch'
 Catch.authenticate username,password
 streams = Catch::Stream.all
 space = streams.first
 note = space.notes.first (will get you the notes details without the text)
 note = space.notes.first.full (gets the full note with the text)
=end

require 'httparty'
require 'ostruct'
require 'json'

module Catch
  class << self
    def authenticate username,password
      $auth = {:username => username, :password => password}
    end

    def auth
      return $auth
    end
  end

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
      p "#{method.to_s.upcase}: #{url}"
      p "    OPTIONS: #{options}"
      resp = HTTParty.send(method,url,options)
      p "#{resp.code}: #{resp.body['status']}"
      json = JSON.parse(resp.body)
      raise SystemCallError,"Error #{resp.code}: #{resp.body["status"]} Message: #{resp.message}" unless resp.code == 200 and json["status"].downcase == "ok"
      return json['result']
    end
  end


  class Stream < CatchItem
    URL = "#{BASEURL}/v3/streams"

    def self.create(options={})
      raise ArgumentError,'name is required' unless options[:name]
      return Stream.new self.post(URL,options)
    end

    def self.all
      return self.get(URL)['streams'].map { |s| Stream.new(s) }
    end

    def notes
      url = "#{URL}/#{self.id}"
      return self.class.get(url)['objects'].map { |n| NoteBare.new(n.merge({:stream => self.id})) }
    end

    def create_note(options={})
      raise ArgumentError,'Text is required' unless options[:text]
      url = "#{BASEURL}/v3/streams/#{stream}"
      self.class.post(url,options)
    end
  end

  # Streams are known as 'spaces' in the UI
  class Space < Stream
  end

  class Note < CatchItem
  end

  class NoteBare < CatchItem
    def full
      url = "#{BASEURL}/v3/streams/#{self.stream}/#{self.id}"
      return Note.new self.class.get(url)
    end
  end

end

