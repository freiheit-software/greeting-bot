require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  'postgresql',
  host:     ENV['DB_HOST'],
  database: ENV['DB_NAME'],
  username: ENV['DB_USER'],
  password: ENV['DB_PASS'],
)