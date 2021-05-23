require "functions_framework"
require "json"
require 'pg'
require 'date'
require 'net/http'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
  require_relative "lib/subscription"
  require_relative "lib/parser"
  require_relative "lib/home_tab_builder"
  require_relative "lib/slack_api"
end

FunctionsFramework.http "send_messages_to_subscribers" do |request|
    Subscription
    .all
    .each do |subscription|
      message = Message.sample Message.messages_for_recipient subscription.subscriber
      SlackApi.new(data:{ text: message.text, channel: subscription.subscriber, link_names: true }).send
      message.update(shown: Date.today)
    end
  ""
end

FunctionsFramework.http "random_greeting" do |request|
  recipient = request.params['user_id']
  message = Message.sample Message.messages_for_recipient recipient
  SlackApi.new(data:{ text: message.text, channel: recipient, link_names: true }).send
  message.update(shown: Date.today)
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

FunctionsFramework.http "handle_greet_command" do |request|
  parser = Parser.new(request: request)

  case parser.command
  when "subscribe"
    Subscription.find_or_create_by(subscriber: parser.channel_id)
    { "response_type" => "ephemeral", "text" => "Subscription successful" }
  when "unsubscribe"
    Subscription.find_by(subscriber: parser.channel_id).try(:destroy)
    { "response_type" => "ephemeral", "text" => "Unsubscribe successful" }
  else
    { "response_type" => "ephemeral", "text" => "Sorry, slash commando, that didn’t work. Please try again." }
  end
end
