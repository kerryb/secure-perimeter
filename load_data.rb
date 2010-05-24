require "db"
require "user"
require "key"
require "application"

fred = User.create! :username => "fred"
localhost = Application.create! :name => "localhost", :host => "localhost", :port => 80, :rewrite_urls => false
orca = Application.create! :name => "orca", :host => "orca.local", :port => 80, :rewrite_urls => false
orca_rewrite = Application.create! :name => "orca_rewrite", :host => "orca.local", :port => 80, :rewrite_urls => true
Key.create! :user => fred, :application => localhost, :key => "key1", :secret => "secret1"
Key.create! :user => fred, :application => orca, :key => "key2", :secret => "secret2"
Key.create! :user => fred, :application => orca_rewrite, :key => "key3", :secret => "secret3"
