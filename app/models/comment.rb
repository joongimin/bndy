class Comment < ActiveRecord::Base
  validates :message, presence: {message: '메시지를 입력해주세요.'}, length: {minimum: 1, maximum: Settings.max_comment_message_length, message: "#{Settings.max_comment_message_length}자 이하로 작성해주세요."}
end
