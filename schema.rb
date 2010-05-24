require "db"

ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :username
  end

  create_table :applications do |t|
    t.string :name
    t.string :host
    t.integer :port
    t.boolean :rewrite_urls
  end

  create_table :keys do |t|
    t.string :key
    t.string :secret
    t.integer :user_id
    t.integer :application_id
  end
end
