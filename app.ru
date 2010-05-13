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
    signature = OAuth::Signature.build Rack::Request.new(env), :consumer_secret => consumer_secret
    env["proxy_host"] = "localhost"
    env["proxy_port"] = 80
    if signature.verify
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

class Proxy < Rack::Proxy
  def rewrite_env env
    @perimeter_host = env["HTTP_HOST"]
    @host = env["HTTP_HOST"] = env["proxy_host"]
    @port = env["SERVER_PORT"] = env["proxy_port"]
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

use Authenticator
run Proxy.new
