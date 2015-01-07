# encoding: utf-8

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
