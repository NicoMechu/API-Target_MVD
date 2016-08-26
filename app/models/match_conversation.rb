# == Schema Information
#
# Table name: match_conversations
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_A_id  :integer
#  user_B_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MatchConversation < ActiveRecord::Base
  belongs_to :user_A, :class_name => 'User'
  belongs_to :user_B, :class_name => 'User'
  belongs_to :topic
  has_many   :messages

  validate   :match_uniqueness

  after_save :notify_match

  def match_uniqueness
    matches_topic = MatchConversation.where(topic_id: topic_id)
    if matches_topic.where(user_A_id: [user_A_id, user_B_id]).where(user_B_id: [user_A_id, user_B_id]).any?
      errors.add(:already_matched, "Already Matched")
    end
  end

  private
    def notify_match
      NotificationService.send_message( self.user_B, 'congratulations you have a new match! :D', self.to_json )
    end
end
