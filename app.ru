require "activesupport"
require "net/http"

module Rack
  class Proxy
    def call env
      request = Rack::Request.new env
      http_method = request.request_method
      request_headers = {}
      env.each do |k, v|
        request_headers[k.sub(/^HTTP_/, '')] = v if k =~ /^HTTP_/
      end
      host = "orca.cloud.nat.bt.com"
      request_headers["HOST"] = host
      Net::HTTP.start(host) do |http|
        request_class = Net::HTTP.const_get(http_method.capitalize)
        request = request_class.new request.path_info, request_headers
        @response = http.request request
      end
      response_headers = {}
      @response.to_hash.each {|k,v| response_headers[k] = v.join "\n"}
      response_headers.delete "status"
      [@response.code, response_headers, @response.body]
    end
  end
end

use Rack::Lint
run Rack::Proxy.new
