require "rubygems"
require "rack/proxy"

class SimpleProxy < Rack::Proxy
  def initialize host, port
    @host, @port = host, port
  end

  def rewrite_env env
    env["HTTP_HOST"] = @host
    env["SERVER_PORT"] = @port.to_s
    env
  end

  def rewrite_response triplet
    status, headers, body = triplet
    headers.delete "status"
    triplet
  end
end

use Rack::Lint
run SimpleProxy.new("orca.cloud.nat.bt.com", 80)
