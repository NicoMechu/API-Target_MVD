# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  label      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string
#

FactoryGirl.define do
  factory :topic do
    label   { Faker::App.name }
  end

end
