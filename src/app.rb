require "functions_framework"
require "json"
require 'pg'
require 'date'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
  require_relative "lib/parser"
end

FunctionsFramework.http "send_message" do |request|
  input = JSON.parse request.body.read rescue {}
  msg = input["message"].to_s
  msg.empty? ? "Greetings, fellow humans!!!" : msg
  message = Message.find 1
  message.formatted_text
end

FunctionsFramework.http "quotes" do |request|
  parser = Parser.new(request: request)

  parser.date.to_s
end
