# encoding: utf-8

require 'spec_helper'

describe Api::V1::PushTokensController do
render_views
  
  before :each do
    @user  = FactoryGirl.create(:user)
    request.headers['Content-Type'] =  "application/json"
    request.headers['X-USER-TOKEN'] =  @user.authentication_token
    @push_token = FactoryGirl.create(:push_token)
  end

  describe "Create push token" do
    describe "valid params" do
      it 'should change the amunt of Push Tokens' do
        expect { 
          post :create, 
          user_id: @user.id, 
          push_token: "#{ Faker::Lorem.characters(20) }" ,
          format: 'json' 
          }.to change { Target.count }.by(1)
      end
    end

    describe "invalid params" do
      it 'should not change the amunt of Push Tokens' do
        expect { post :create, 
          user_id: @user.id, 
          push_token: "#{@push_token.push_token}" 
          format: 'json' 
          }.not_to change { Target.count }
      end
    end
  end
end
