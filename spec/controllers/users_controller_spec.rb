# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do
  render_views

  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
  end

  describe "PUT 'update/:id'" do
    it 'allows an user to be updated' do
      @attr = { username: 'new username' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      put :update, id: @user.id, user: @attr, format: 'json'
      parsed_response = JSON.parse(response.body)
      @user.reload
      expect(response.response_code).to be 200
      expect(@user.username).to eq @attr[:username]
    end

    it 'should not allow to update an user (bad auth)' do
      @attr = { username: 'new username' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token + 'wrong'
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(response.status).to eq 401
      expect(@user.username).to_not eq @attr[:username]
    end

    it 'should not allow to update an user (bad data)' do
      @attr = { email: 'notanemail' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(@user.username).to_not eq @attr[:username]
      expect(response.response_code).to eq 400
    end
  end
end
