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

FactoryGirl.define do
  factory :match_conversation do
    topic
    association :user_a, factory: :user
    association :user_b, factory: :user
  end
end
