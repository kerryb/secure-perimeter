require "active_record"

db_config = YAML.load_file("config.yml")['database']
ActiveRecord::Base.establish_connection db_config
