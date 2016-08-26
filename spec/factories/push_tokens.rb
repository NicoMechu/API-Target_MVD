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

FactoryGirl.define do
  factory :push_token do
    user
    push_token  { Faker::Lorem.characters(20) }
  end

end
