# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  topic_id   :integer
#  lat        :float
#  lng        :float
#  radius     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :target do
    user
    topic
    lat     { Faker::Number.decimal(2, 6) }
    lng     { Faker::Number.decimal(2, 6) } 
    radius  { Faker::Number.number(7) } 
  end

end
