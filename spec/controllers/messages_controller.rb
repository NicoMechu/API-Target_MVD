# encoding: utf-8

require 'spec_helper'


describe Api::V1::MessagesController do
  Delayed::Worker.delay_jobs = false
  render_views

  before :each do
    @user  = FactoryGirl.create(:user)
    @match = FactoryGirl.create(:match_conversation, user_a: @user)
    request.headers['Content-Type'] =  "application/json"
    request.headers['X-USER-TOKEN'] =  @user.authentication_token
  end

  describe 'GET index' do
    it 'load' do
      get :index, user_id: @user.id, match_conversation_id: @match.id, format: 'json' 
      expect(response.status).to eq(200)
    end
  end
end
