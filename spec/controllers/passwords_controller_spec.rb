# encoding: utf-8

require 'spec_helper'

describe Api::V1::PasswordsController do
  before :each do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    Delayed::Worker.delay_jobs = false
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = FactoryGirl.create(
      :user,
      password: 'mypass123'
    )
    @password_token = @user.send :set_reset_password_token
  end

  context 'with valid params' do
    it 'should success and send an email' do
      post  :create,
            user: {
              email: @user.email
            },
            format: 'json'
      expect(response.response_code).to be 204
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'should change the password' do
      put :update,
          user: {
            password: '123456789',
            password_confirmation: '123456789',
            reset_password_token: @password_token
          },
          format: 'json'
      expect(response.response_code).to be 204
    end
  end

  context 'with invalid params' do
    it 'should not success' do
      post  :create,
            user: {
              email: 'notvalid@lala.com'
            },
            format: 'json'
      expect(response.status).to eq 400
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end

    # reset_password_token is harcoded to match the encryption of the one stored on the db
    it 'should not change the password if confirmation does not match' do
      put :update,
          user: {
            password: '123456789',
            password_confirmation: 'different',
            reset_password_token: '59J1m_UzbFzfiY_4xSXn'
          },
          format: 'json'
      expect(response.status).to eq 400
    end

    it 'should not change the password if token is invalid' do
      put :update,
          user: {
            password: '123456789',
            password_confirmation: '123456789',
            reset_password_token: 'not valid token'
          },
          format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(response.status).to eq 400
    end
  end
end
