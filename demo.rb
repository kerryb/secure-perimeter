#!/usr/bin/env ruby

require 'rubygems'
require 'oauth'

consumer = OAuth::Consumer.new "key1", "secret1",
  :site               => "http://localhost:9292",
  :scheme             => :header,
  :http_method        => :post,
  :proxy => ENV["http_proxy"]

access_token = OAuth::AccessToken.new consumer
puts "key1:"
puts access_token.get "/"

consumer = OAuth::Consumer.new "key2", "secret2",
  :site               => "http://localhost:9292",
  :scheme             => :header,
  :http_method        => :post,
  :proxy => ENV["http_proxy"]

access_token = OAuth::AccessToken.new consumer
puts "\nkey2:"
puts access_token.get "/content_cache", "Accept" => "application/xml"

consumer = OAuth::Consumer.new "key3", "secret3",
  :site               => "http://localhost:9292",
  :scheme             => :header,
  :http_method        => :post,
  :proxy => ENV["http_proxy"]

access_token = OAuth::AccessToken.new consumer
puts "\nkey3:"
puts access_token.get "/content_cache", "Accept" => "application/xml"
