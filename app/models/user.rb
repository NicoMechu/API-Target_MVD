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
#  facebook_id            :string           default("")
#  created_at             :datetime
#  updated_at             :datetime
#  gender                 :integer
#  name                   :string
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_facebook_id           (facebook_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include Authenticable
  include Facebookeable

  has_many :targets , dependent: :destroy

  validates :name, presence: true, allow_blank: false, allow_nil: false
  validates :email, uniqueness: true, allow_blank: true, allow_nil: true unless :facebook_id.present?
  validates_presence_of :password unless :facebook_id.present?
  validates :facebook_id, uniqueness: true,allow_blank: true, allow_nil: true

  enum gender: [:female , :male]
  validates_presence_of :gender

  def to_s
    return name
  end
end

