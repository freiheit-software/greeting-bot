require 'date'

class Parser
  attr_accessor :request

  def initialize(request:)
    @request = request
  end

  def user_id
    request.params["user_id"]
  end

  def user_name
    request.params["user_name"]
  end

  def channel_id
    request.params["channel_id"]
  end

  def challenge
    body = JSON.parse request.body.read rescue {}
    body["challenge"].to_s
  end

  # [[quote1], [quote2]]
  def quotes
    input.gsub(/[“”]/, '"').scan(/"([^"]*)"/)
  end

  # [["@USER_ID|user.handle"]]
  def creator_id
    ids = input.scan(/<([^>]*)>/)
    ids.first.first.split("|")&.first if ids.present?
  end

  def date
    if week_days.include? date_text
      beginning_of_week + week_days.index(date_text) + 1
    else
      Date.parse(date_text) rescue Date.today
    end
  end

  def command
    tokens.first
  end

  def parameters
    command, *params = tokens
    params
  end

  def input
    @input ||= request.params["text"]
  end

  private

  def tokens
    @tokens ||= input.split
  end

  def week_days
    @week_days ||= %w(monday tuesday wednesday thursday friday saturday sunday)
  end

  def beginning_of_week
    Date.today - Date.today.cwday + 1
  end

  def date_text
    input.split(" on ")[1]&.strip&.downcase
  end
end
