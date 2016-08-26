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

FactoryGirl.define do
  factory :match_conversation do
    topic
    association :user_A, factory: :user
    association :user_B, factory: :user
  end
end
