#!/usr/bin/env ruby

require 'rubygems'
require 'oauth'

options = {
  :site               => "http://localhost:9292",
  :scheme             => :header,
  :http_method        => :post
}

puts "unknown key:"
consumer = OAuth::Consumer.new "unknown_key", "secret", options
access_token = OAuth::AccessToken.new consumer
puts access_token.get "/"

puts "key1:"
consumer = OAuth::Consumer.new "key1", "secret1", options
access_token = OAuth::AccessToken.new consumer
puts access_token.get "/"

puts "\nkey1 with wrong secret:"
consumer = OAuth::Consumer.new "key1", "wrong_secret", options
access_token = OAuth::AccessToken.new consumer
puts access_token.get "/"

puts "\nkey2:"
consumer = OAuth::Consumer.new "key2", "secret2", options
access_token = OAuth::AccessToken.new consumer
puts access_token.get "/content_cache", "Accept" => "application/xml"

puts "\nkey3:"
consumer = OAuth::Consumer.new "key3", "secret3", options
access_token = OAuth::AccessToken.new consumer
puts access_token.get "/content_cache", "Accept" => "application/xml"
