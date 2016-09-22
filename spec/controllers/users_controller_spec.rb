# encoding: utf-8

require 'spec_helper'

describe Api::V1::UsersController do
  render_views

  before(:each) do
    @user = FactoryGirl.create(:user)
    @friend = FactoryGirl.create(:user)
    request.headers['Content-Type'] =  "application/json"
    request.headers['X-USER-TOKEN'] =  @user.authentication_token
  end

  describe "PUT 'update/:id'" do
    it 'allows an user to be updated' do
      @attr = { name: 'new user name' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      put :update, id: @user.id, user: @attr, format: 'json'
      parsed_response = JSON.parse(response.body)
      @user.reload
      expect(response.response_code).to be 200
      expect(@user.name).to eq @attr[:name]
    end

    it 'should not allow to update an user (bad auth)' do
      @attr = { name: 'new user name' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token + 'wrong'
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(response.status).to eq 401
      expect(@user.name).to_not eq @attr[:name]
    end

    it 'should not allow to update an user (bad data)' do
      @attr = { email: 'notanemail' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(@user.name).to_not eq @attr[:name]
      expect(response.response_code).to eq 400
    end
  end

  describe "GET :id/unread_conversations" do

    it 'should return the correct count of unread conversations' do
      @match_1 = FactoryGirl.create(:match_conversation, user_a: @user)
      @match_2 = FactoryGirl.create(:match_conversation, user_a: @user)
      @match_3 = FactoryGirl.create(:match_conversation, user_a: @user)
      5.times do
        FactoryGirl.create(:message, match_conversation: @match_1)
      end
      2.times do
        FactoryGirl.create(:message, match_conversation: @match_2)
      end
      get :unread_conversations, user_id: @user.id
      expect(response.response_code).to eq 200
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['unread_matches']).to eq 2
    end
  end
end
