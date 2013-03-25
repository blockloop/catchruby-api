Dir['models/*.rb'].each { |m| require File.expand_path(m) }

module Catch
  class << self
    def authenticate username,password
      $auth = {:username => username, :password => password}
    end

    def auth
      return $auth
    end

  end

end

