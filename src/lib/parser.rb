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

  # [[quote1], [quote2]]
  def quotes
    command.scan(/"([^"]*)"/)
  end

  # [["@USER_ID|user.handle"]]
  def users
    command.scan(/<([^>]*)>/).split("|").first
  end

  def date
    if week_days.include? date_text
      beginning_of_week + week_days.index(date_text) + 1
    else
      Date.parse(date_text) rescue Date.today
    end
  end

  private

  def week_days
    @week_days ||= %w(monday tuesday wednesday thursday friday saturday sunday)
  end

  def beginning_of_week
    Date.today - Date.today.cwday + 1
  end

  def command
    @command ||= request.params["text"]
  end

  def date_text
    command.split(" on ")[1]&.strip&.downcase
  end
end