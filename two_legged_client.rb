#!/usr/bin/env ruby

require 'rubygems'
require 'oauth'

consumer_key = "key"
consumer_secret = "secret"

consumer = OAuth::Consumer.new consumer_key, consumer_secret,
  :site               => "http://term.ie",
  :scheme             => :header,
  :http_method        => :post,
  :request_token_path => "/oauth/example/request_token.php",
  :access_token_path  => "/oauth/example/access_token.php",
  :authorize_path     => "/oauth/example/authorize.php",
  :proxy => ENV["http_proxy"]

access_token = OAuth::AccessToken.new consumer
puts access_token.get("/oauth/example/echo_api.php")
