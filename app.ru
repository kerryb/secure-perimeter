require "rubygems"
require "yaml"
require "rack/proxy"
require "oauth"
require "oauth/request_proxy/rack_request"
require "db"
require "user"
require "key"
require "application"

class Authenticator
  include OAuth::Helper

  def initialize app
    @app = app
  end

  def call env
    @host = env["HTTP_HOST"]
    request_proxy = OAuth::RequestProxy.proxy Rack::Request.new(env)
    key = Key.find_by_key request_proxy.oauth_consumer_key, :include => :application
    return oauth_error unless key
    env["rewrite_urls"] = key.application.rewrite_urls
    env["proxy_host"] = key.application.host
    env["proxy_port"] = key.application.port
    if OAuth::Signature.verify request_proxy, :consumer_secret => key.secret
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
    @rewrite_urls = env["rewrite_urls"]
    env
  end

  def rewrite_response triplet
    status, headers, @response = triplet
    headers.delete "status"
    if @rewrite_urls
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
