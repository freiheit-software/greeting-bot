class Message < ActiveRecord::Base

  scope :quotes, -> { where(category: 1) }
  scope :appreciations, -> { where(category: 2) }
  scope :trivia, -> { where(category: 3) }
  scope :published, -> { where.not(shown: nil) }

  def formatted_text
    "+++ #{text} +++"
  end
end
