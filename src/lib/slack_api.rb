require 'net/http'
require 'date'
require_relative "message"

class SlackApi
  attr_accessor :data

  def initialize(data:)
    @data = data
  end

  def uri
    URI('https://slack.com/api/chat.postMessage')
  end

  def headers
    { "Content-Type" => "application/json; charset=UTF-8", "Authorization" => "Bearer " + ENV['SLACK_BOT_TOKEN'] }
  end

  def send
    Net::HTTP.post(uri, data.to_json, headers)
  end
end