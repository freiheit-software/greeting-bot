require "functions_framework"
require "json"
require 'pg'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
end

FunctionsFramework.http "send_message" do |request|
  input = JSON.parse request.body.read rescue {}
  msg = input["message"].to_s
  msg.empty? ? "Greetings, fellow humans!!!" : msg
  message = Message.find 1
  message.formatted_text
end
