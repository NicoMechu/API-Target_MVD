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

  describe 'POST create' do
    describe 'with valid params' do
      it 'should change the amount of Messages' do
        expect { 
          post :create, 
            user_id: @user.id, 
            match_conversation_id: @match.id,
            text: "#{ Faker::Lorem.characters(20) }" ,
            format: 'json' 
          }.to change { @match.messages.count }.by(1)
      end

      it 'should return a valid response' do
        post :create, 
          user_id: @user.id, 
          match_conversation_id: @match.id, 
          text: "#{ Faker::Lorem.characters(20) }", 
          format: 'json' 
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['sender']).to eq @user.id
        expect(parsed_response['receiver']).to eq @match.other_party(@user).id
        expect(response.status).to eq 200
      end

      describe 'with inactive conversation' do
        it 'should return an error message' do
          @match.target_a_id = nil
          @match.save
          post :create, 
            user_id: @user.id, 
            match_conversation_id: @match.id, 
            text: "#{ Faker::Lorem.characters(20) }", 
            format: 'json'
          expect(response.status).to eq 400
        end

        it 'should not create the message' do
          @match.target_a_id = nil
          @match.save
          expect{  
          post :create, 
            user_id: @user.id, 
            match_conversation_id: @match.id, 
            text: "#{ Faker::Lorem.characters(20) }", 
            format: 'json'
          }.not_to change { Message.count }
        end
      end      
    end

    describe 'with invalid params' do
      it 'should not change the amount of Messages' do
        expect { 
          post :create, 
            user_id: @user.id, 
            match_conversation_id: @match.id,
            format: 'json' 
          }.not_to change { @match.messages.count }
      end
    end
  end
end
