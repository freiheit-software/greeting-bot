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
  def challenge
    body = JSON.parse request.body.read rescue {}
    body["challenge"].to_s
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
    Date.parse(date_text) rescue Date.today
  end
  private
  def command
    @command ||= request.params["text"]
  end
  def date_text
    command.split(" on ")[1]&.strip
  end
end
