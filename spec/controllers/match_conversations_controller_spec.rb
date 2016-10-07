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

  describe 'DELETE destroy' do
    before :each do
      @user_1  = FactoryGirl.create(:user)
      @user_2  = FactoryGirl.create(:user)
      @match   = FactoryGirl.create(:match_conversation, user_a: @user_1, user_b: @user_2)
      request.headers['X-USER-TOKEN'] =  @user_1.authentication_token
    end

    describe 'only one deletes the conversation' do
      it "shouldn't change the amount of matches" do 
        expect{
          delete :destroy, 
          user_id: @user_1.id, 
          id: @match.id, 
          format: 'json'
        }.not_to change { MatchConversation.count } 
      end

      it "should change the amount of visible matches for that user" do
        expect{
          delete :destroy, 
          user_id: @user_1.id, 
          id: @match.id, 
          format: 'json'
        }.to change { @user_1.all_matches.count }.by(-1) 
      end

      it "shouldn't change the amount of visible matches for the other user" do
        expect{
          delete :destroy, 
          user_id: @user_1.id, 
          id: @match.id, 
          format: 'json'
        }.not_to change { @user_2.all_matches.count }
      end
    end

    describe 'both users delete the conversation' do 
      it "should delete the match" do
        @match   = FactoryGirl.create(:match_conversation, user_a: @user_1, user_b: @user_2, visible_b: false);
        delete :destroy, user_id: @user_1.id, id: @match.id, format: 'json'
        expect( MatchConversation.find_by_id(@match.id) ).to eq nil
      end

      # it "should change the amount of matches" do
      #   @match   = FactoryGirl.create(:match_conversation, user_a: @user_1, user_b: @user_2, visible_b: false);
      #   expect{
      #     delete :destroy, 
      #       user_id: @user_1.id, 
      #       id: @match.id, 
      #       format: 'json'
      #   }.to change { MatchConversation.count }.by(-1)
      # end
    end
  end
end
