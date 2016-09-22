# == Schema Information
#
# Table name: messages
#
#  id                    :integer          not null, primary key
#  text                  :string
#  user_id               :integer
#  match_conversation_id :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :match_conversation

  validates :text, presence: true

  after_create :send_message

  scope :recent, -> { order('created_at DESC') }

  scope :before, -> (id) { where(' id < ? ', id)}

  scope :lastOne, -> { recent.first }

  scope :after, -> (time) { where(' updated_at > ? ', time) }

  def receiver
    match_conversation.other_party(user)
  end
  
  def as_json(options={})
    { 
      id:   id, 
      text: text, 
      match_conversation: match_conversation_id,
      sender:  user_id,
      time:{
          date:{
            day:   updated_at.day,
            month: updated_at.month,
            year:  updated_at.year
          },
          hour: updated_at.hour,
          min:  updated_at.min,
          sec:  updated_at.sec
      }
    }
  end

  protected
    def send_message
      NotificationService.send_message(self)
    end
end
