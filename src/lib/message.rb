class Message < ActiveRecord::Base
  def formatted_text
    "+++ #{text} +++"
  end
end
