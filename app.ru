require "rubygems"
require "rack/proxy"
require "oauth"
require "oauth/request_proxy/rack_request"

class Authenticator
  include OAuth::Helper

  def initialize app
    @app = app
  end

  def call env
    @host = env["HTTP_HOST"]
    consumer_secret = "secret"
    if OAuth::Signature.verify Rack::Request.new(env), :consumer_secret => consumer_secret
      @app.call env
    else
      oauth_error
    end
  rescue OAuth::Signature::UnknownSignatureMethod
    oauth_error
  end

  private
  def oauth_error
    [401, {"Content-Type" => "text/plain",
      "WWW-Authenticate" => %(OAuth realm="http://#{@host}")}, "Invalid OAuth Request"]
  end
end

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
use Authenticator
use Rack::Lint
run SimpleProxy.new("orca.local", 80)
