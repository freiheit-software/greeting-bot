require "functions_framework"
require "json"
require 'pg'


FunctionsFramework.on_startup do |function|
  require 'active_record'

  ActiveRecord::Base.establish_connection(
    adapter:  'postgresql',
    host:     ENV['DB_HOST'],
    database: ENV['DB_NAME'],
    username: ENV['DB_USER'],
    password: ENV['DB_PASS'],
  )

  class Message < ActiveRecord::Base
    
  end
end


FunctionsFramework.http "send_message" do |request|
  input = JSON.parse request.body.read rescue {}
  msg = input["message"].to_s
  msg.empty? ? "Greetings, fellow humans!!!" : msg
  message = Message.find 1
  message.text
end
