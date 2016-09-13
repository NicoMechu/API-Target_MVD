# == Schema Information
#
# Table name: match_conversations
#
#  id            :integer          not null, primary key
#  topic_id      :integer
#  user_a_id     :integer
#  user_b_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  channel_id    :string
#  last_logout_a :datetime
#  last_logout_b :datetime
#

class MatchConversation < ActiveRecord::Base
  belongs_to :user_a, :class_name => 'User'
  belongs_to :user_b, :class_name => 'User'
  belongs_to :topic
  has_many   :messages

  validate   :match_uniqueness, on: :create
  validates  :channel_id, uniqueness: true

  before_validation :set_channel_id, on: [:create, :update]
  after_save        :notify

  def match_uniqueness
    matches_topic = MatchConversation.where(topic_id: topic_id)
    if matches_topic.where(user_a_id: [user_a_id, user_b_id]).where(user_b_id: [user_a_id, user_b_id]).any?
      errors.add(:already_matched, "Already Matched")
    end
  end

  def other_party(current_user)
    current_user == user_a ? user_b : user_a
  end

  def unread(user)
    last_logout = user_a_id == user.id ? last_logout_a : last_logout_b
    if last_logout.nil?
      messages.all
    else
      messages.after(last_logout)
    end
  end
  
  def close_chat(user)
    if user == user_a
      self.last_logout_a = Time.now
    else
      self.last_logout_b = Time.now
    end
  end

  private
    def notify
      NotificationService.notify_match(self)
    end

    def set_channel_id
      self.channel_id = loop do
        temp = SecureRandom.urlsafe_base64(16)
        break temp unless MatchConversation.find_by(channel_id: temp).present?
      end
    end
end
