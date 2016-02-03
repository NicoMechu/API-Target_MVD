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
#  sign_in_count          :integer          default("0"), not null
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
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_facebook_id           (facebook_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username)
#

require 'spec_helper'

RSpec.describe User do
  it 'has a valid factory' do
    old_count = User.count
    expect(FactoryGirl.create(:user)).to be_valid
    FactoryGirl.create_list(:user, 9)
    expect(User.count).to eq old_count + 10
  end

  it 'full_name returns correct name' do
    # Email users
    email_user = FactoryGirl.create(:user)
    full_name = email_user.full_name
    expect(full_name).to eq email_user.username
    # Facebook users
    fb_user = FactoryGirl.create(:user_with_fb)
    full_name_fb = fb_user.full_name
    expect(full_name_fb).to eq fb_user.first_name + ' ' + fb_user.last_name
  end
end
