require "functions_framework"
require "json"
require 'pg'
require 'net/http'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
  require_relative "lib/parser"
  require_relative "lib/home_tab_builder"
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

FunctionsFramework.http "events" do |request|
  body = JSON.parse request.body.read
  parser = Parser.new request: request
  user_id = body['event']['user']

  data = {
    "user_id": user_id,
    "view": {
        "type": "home",
        "blocks": []
    }
  }

  home_tab = HomeTabBuilder.new user_id: user_id

  data[:view][:blocks].push(home_tab.create_header())
  data[:view][:blocks].push(home_tab.create_quotes_title())

  Message.quotes.published.order(shown: :desc).each do |message|
    home_tab.create_quote(message).each do |block|
      data[:view][:blocks].push(block)
    end
  end

  data[:view][:blocks].push(home_tab.create_appreciation_title)

  Message.appreciations.published.order(shown: :desc).each do |message|
    home_tab.create_appreciation(message).each do |block|
      data[:view][:blocks].push(block)
    end
  end

  data[:view][:blocks].push(home_tab.create_trivia_title())

  Message.trivia.published.order(shown: :desc).each do |message|
    home_tab.create_trivia(message).each do |block|
      data[:view][:blocks].push(block)
    end
  end

  uri = URI('https://slack.com/api/views.publish')
  res = Net::HTTP.post(
    uri,
    data.to_json,
    {"Content-Type" => "application/json; charset=UTF-8", "Authorization" => "Bearer " + ENV['SLACK_BOT_TOKEN'] }
  )

  ""
end
