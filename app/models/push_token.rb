# == Schema Information
#
# Table name: push_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  push_token :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PushToken < ActiveRecord::Base
  belongs_to :user

  validates :push_token, presence: true, uniqueness: true
end
