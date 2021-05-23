require 'date'

class Message < ActiveRecord::Base

  scope :quotes, -> { where(category: 1) }
  scope :appreciations, -> { where(category: 2) }
  scope :trivia, -> { where(category: 3) }
  scope :published, -> { where.not(shown: nil) }

  def formatted_text
    "+++ #{text} +++"
  end

  def days_since_shown
    return 100.0 if shown.nil?
    day_diff = Float(Date.today - shown + 1.0)
    return 100.0 if day_diff > 100.0
    day_diff
  end

  def self.sample(messages)
    sum_day_diffs = messages.map { |message| message.days_since_shown }.reduce(:+)
    weighted_messages = messages.map { |message| { "message" => message, "weight" => (message.days_since_shown) / sum_day_diffs } }
    weighted_messages.max_by { |weighted_message| rand ** (1.0 / weighted_message["weight"]) }["message"]
  end

  def self.messages_for_recipient(recipient)
    where(recipient: nil) + where(recipient: recipient)
  end
end
