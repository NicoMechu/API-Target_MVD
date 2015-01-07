# encoding: utf-8

require 'spec_helper'

describe Api::V1::RegistrationsController do
  render_views

  before(:each) do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
  end

  describe "POST 'users/'" do
    it 'allows to create an user' do
      @attr = { username: 'test', email: 'test@test.com', password: '12345678', password_confirmation: '12345678' }
      post :create, user: @attr, format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      new_user = User.find_by_email('test@test.com')
      expect(new_user).to_not be_nil
    end

    it 'should not create an user with invalid email' do
      @attr = { username: 'test', email: 'notanemail', password: '12345678', password_confirmation: '12345678' }
      post :create, user: @attr, format: 'json'
      new_user = User.find_by_email('test@test.com')
      expect(new_user).to be_nil
      expect(response.response_code).to eq 400
    end

    it 'should not create an user with invalid password' do
      @attr = { username: 'test', email: 'email@email.com', password: 'short', password_confirmation: 'short' }
      post :create, user: @attr, format: 'json'
      new_user = User.find_by_email('test@test.com')
      expect(new_user).to be_nil
      expect(response.response_code).to eq 400
    end

    it 'should not create an user if passwords dont match' do
      @attr = { username: 'test', email: 'email@email.com', password: 'shouldmatch', password_confirmation: 'dontmatch' }
      post :create, user: @attr, format: 'json'
      new_user = User.find_by_email('test@test.com')
      expect(new_user).to be_nil
      expect(response.response_code).to eq 400
    end
  end
end
