class HomeTabBuilder 
  attr_accessor :user_id

  def initialize(user_id:)
    @user_id = user_id
  end

  def create_header()
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "Welcome to our greeting bot."
      }
    }
  end

  def create_title(title)
    {
      "type": "header",
      "text": {
        "type": "plain_text",
        "text": title,
        "emoji": true
      }
    }
  end

  def create_quotes_title()
    self.create_title('Quotes 💬')
  end

  def create_appreciation_title()
    self.create_title('Appreciations 💚')
  end

  def create_trivia_title()
    self.create_title('Trivia 🤓')
  end

  def create_quote(message)
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{message.text}"
        }
      },
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "<@#{message.author}> on #{message.date}"
          }
        ]
      },
    ]
  end

  def create_appreciation(message)
    [
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "<@#{message.creator}> sent that appreciation on #{message.date}"
          }
        ]
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{message.text}"
        }
      }
    ]
  end

  def create_trivia(message)
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{message.text}"
        }
      },
      {
        "type": "context",
        "elements": [
          {
            "type": "mrkdwn",
            "text": "Created on #{message.date}"
          }
        ]
      },
    ]
  end

end
