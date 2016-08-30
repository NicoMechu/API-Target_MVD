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

FactoryGirl.define do
  factory :message do
    user
    match_conversation
    text                { Faker::Lorem.sentence }
  end
end
