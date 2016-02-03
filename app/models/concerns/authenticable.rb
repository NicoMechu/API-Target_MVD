# encoding: utf-8

module Authenticable
  extend ActiveSupport::Concern

  included do
    acts_as_token_authenticatable
    devise :database_authenticatable,  #  Password and password confirmation fields
           :recoverable,               #  Reset the password
           :registerable,
           :trackable,                 #  Track the user IP
           :validatable,               #  Validate the email
           :async                      #  Send emails async

    validates :email, uniqueness: true, allow_blank: true, allow_nil: true
    validates :encrypted_password, uniqueness: false, allow_nil: true

    def invalidate_token
      self.authentication_token = ''
      self.save!
    end

    protected

    def password_required?
      !password.nil? || !password_confirmation.nil?
    end

    def email_required?
      false
    end
  end
end
