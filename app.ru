require "rubygems"
require "rack/proxy"

class SimpleProxy < Rack::Proxy
  def initialize host, port
    @host, @port = host, port
  end

  def rewrite_env env
    @perimeter_host = env["HTTP_HOST"]
    env["HTTP_HOST"] = @host
    env["SERVER_PORT"] = @port.to_s
    env
  end

  def rewrite_response triplet
    status, headers, @response = triplet
    headers.delete "status"
    if headers["Content-Type"].include? "text/html"
      [status, headers, self]
    else
      [status, headers, @response]
    end
  end

  def each(&block)
    @response.each do |str|
      yield str.gsub(/#{@host}(:#{@port})?/, @perimeter_host)
    end
  end
end

use Rack::Lint
run SimpleProxy.new("orca.local", 80)
