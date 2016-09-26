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
#  title_a       :string
#  title_b       :string
#  target_a_id   :integer
#  target_b_id   :integer
#  visible_a     :boolean          default(TRUE)
#  visible_b     :boolean          default(TRUE)
#

FactoryGirl.define do
  factory :match_conversation do
    topic
    association :user_a, factory: :user
    association :user_b, factory: :user
    target_a_id 1
    target_b_id 2
    visible_a  true
    visible_b  true
  end
end
