require_relative 'catch_item'
require 'awesome_print'

module Catch
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
      url = "#{URL}/#{self.id}?full=1"
      return self.class.get(url)['objects'].map { |n| Note.new(n.merge({:stream => self.id})) }
    end

    def create_note(options={})
      raise ArgumentError,'Text is required' unless options[:text]
      url = "#{BASEURL}/v3/streams/#{stream}"
      self.class.post(url,options)
    end

    def search query,options={}
      # https://api.catch.com/v3/streams/default?q=r8&tags=audi&limit=1&offset=0&full=1
      raise ArgumentError,'query is required' unless query
      url = "#{URL}/#{self.id}?full=1"
      options.merge!(:q => query)
      # ap self.class.get(url,options)['objects']
      return self.class.get(url,options)['objects'].map { |o| Note.new o }
    end

  end

  # Streams are known as 'spaces' in the UI
  class Space < Stream
  end
end