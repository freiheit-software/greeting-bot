require "functions_framework"
require "json"
require 'pg'
require 'net/http'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
end

FunctionsFramework.http "send_message" do |request|
  msg = Message.find 1
  data = {
    "text" => msg.formatted_text,
    "channel" => "#hackathon-may-2021"
  }
  uri = URI('https://slack.com/api/chat.postMessage')
  res = Net::HTTP.post(uri,
	data.to_json,
	{"Content-Type" => "application/json; charset=UTF-8", "Authorization" => "Bearer " + ENV['SLACK_BOT_TOKEN'] })
  puts res.body
  ""
end
