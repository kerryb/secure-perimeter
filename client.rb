#!/usr/bin/env ruby

require 'rubygems'
require 'oauth'

consumer_key = "key"
consumer_secret = "secret"

consumer = OAuth::Consumer.new consumer_key, consumer_secret,
  :site               => "http://localhost:9292",
  :scheme             => :header,
  :http_method        => :post,
  :proxy => ENV["http_proxy"]

access_token = OAuth::AccessToken.new consumer
puts access_token.get("/", "Accept" => "application/xml")
