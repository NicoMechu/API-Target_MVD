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
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  authentication_token   :string           default("")
#  username               :string           default("")
#  facebook_id            :string           default("")
#  first_name             :string           default("")
#  last_name              :string           default("")
#
class User < ActiveRecord::Base
  include Authenticable
  include Facebookeable

  validates :username, uniqueness: true, allow_blank: true, allow_nil: true

  def full_name
    return username unless first_name.present?
    "#{first_name} #{last_name}"
  end

  protected

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    false
  end
end
