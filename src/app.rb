require "functions_framework"
require "json"
require 'pg'
require 'net/http'

FunctionsFramework.on_startup do |function|
  require_relative "db"
  require_relative "lib/message"
  require_relative "lib/parser"
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

  data = {
    "user_id": body["event"]["user"],
    "view": {
        "type": "home",
        "blocks": [
        {
          "type": "section",
          "text": {
            "type": "mrkdwn",
            "text": "Welcome to our greeting bot."
          }
        },
      ]
    }
  }

  data[:view][:blocks].push({
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Quotes 💬",
      "emoji": true
    }
  })

  Message.quotes.published.order(shown: :desc).each do |message|
    data[:view][:blocks].push({
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "#{message.text}"
      }
    })
    data[:view][:blocks].push({
			"type": "context",
			"elements": [
				{
					"type": "mrkdwn",
					"text": "<@#{message.author}> on #{message.date}"
				}
			]
		})
  end

  data[:view][:blocks].push({
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Appreciations 💚",
      "emoji": true
    }
  })

  Message.appreciations.published.order(shown: :desc).each do |message|
    data[:view][:blocks].push({
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "#{message.text}"
      }
    })
    data[:view][:blocks].push({
			"type": "context",
			"elements": [
				{
					"type": "mrkdwn",
					"text": "<@#{message.creator}> sent that appreciation on #{message.date}"
				}
			]
		})
  end

  data[:view][:blocks].push({
    "type": "header",
    "text": {
      "type": "plain_text",
      "text": "Trivia 🤓",
      "emoji": true
    }
  })

  Message.trivia.published.order(shown: :desc).each do |message|
    data[:view][:blocks].push({
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "#{message.text}"
      }
    })
    data[:view][:blocks].push({
			"type": "context",
			"elements": [
				{
					"type": "mrkdwn",
					"text": "Created on #{message.date}"
				}
			]
		})
  end

  uri = URI('https://slack.com/api/views.publish')
  res = Net::HTTP.post(
    uri,
    data.to_json,
    {"Content-Type" => "application/json; charset=UTF-8", "Authorization" => "Bearer " + ENV['SLACK_BOT_TOKEN'] }
  )

  ""
end
