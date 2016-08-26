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
end
