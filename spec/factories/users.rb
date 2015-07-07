# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default("")
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  authentication_token   :string           default("")
#  first_name             :string           default("")
#  last_name              :string           default("")
#  username               :string           default("")
#  facebook_id            :string           default("")
#  created_at             :datetime
#  updated_at             :datetime
#


# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class: 'User' do
    email     { Faker::Internet.email }
    password  { Faker::Internet.password(8) }
    sequence(:username) { |n| "#{n}#{Faker::Internet.user_name}" }
  end

  factory :user_with_fb, class: 'User' do
    facebook_id { Faker::Number.number(10).to_s }
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
  end
end
