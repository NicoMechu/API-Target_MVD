# encoding: utf-8

require 'spec_helper'

describe Api::V1::MatchConversationsController do
  describe 'GET index' do
    it 'load' do
      @user  = FactoryGirl.create(:user)
      request.headers['Content-Type'] =  "application/json"
      request.headers['X-USER-TOKEN'] =  @user.authentication_token
      get :index, user_id: @user.id, format: 'json' 
      expect(response.status).to eq(200)
    end
  end
end
