# encoding: utf-8

require 'spec_helper'

describe Api::V1::MatchConversationsController do
  render_views

  before :each do
    @user  = FactoryGirl.create(:user)
    @match = FactoryGirl.create(:match_conversation, user_a: @user)
    @message_first  = FactoryGirl.create(:message, match_conversation: @match, user: @user)
    @message_last   = FactoryGirl.create(:message, match_conversation: @match, user: @user)
    request.headers['Content-Type'] =  "application/json"
    request.headers['X-USER-TOKEN'] =  @user.authentication_token
  end 

  describe 'GET index' do
    it 'load' do
      @user  = FactoryGirl.create(:user)
      get :index, user_id: @user.id, format: 'json' 
      expect(response.status).to eq(200)
    end
  end

  describe 'show' do
    it 'should return correct response' do
      get :show, user_id: @user.id, id:@match.id, format: 'json' 
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['user']['user_id']).to eq @match.other_party(@user).id
      expect(parsed_response['unread']).to eq 2
      expect(parsed_response['last_message']['id']).to eq @message_last.id
    end
  end

  describe 'close' do
    it 'should change the amount of unread messages to 0' do
      post  :close, user_id: @user.id, match_conversation_id: @match.id, format: 'json'
      get   :show,  user_id: @user.id, id: @match.id, format: 'json'
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['unread']).to eq 0
    end
  end
end
