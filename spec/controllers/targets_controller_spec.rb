require 'rails_helper'

RSpec.describe  Api::V1::TargetsController, type: :controller do
  Delayed::Worker.delay_jobs = false
  render_views
  
  before :each do
    @user  = FactoryGirl.create(:user)
    request.headers['Content-Type'] =  "application/json"
    request.headers['X-USER-TOKEN'] =  @user.authentication_token
  end

  describe 'GET index' do
    it 'load' do
      get :index, user_id: @user.id, format: 'json' 
      expect(response.status).to eq(200)
    end
  end

  describe 'POST create' do
    before :each do
      @topic = FactoryGirl.create(:topic)
      @near_target = FactoryGirl.create(:target, lat: -34.91989495 ,lng: -56.16974832 ,radius: 1000 , topic: @topic)
      FactoryGirl.create(:target, lat: -34.60400053, lng: -58.37508202, radius: 1000, topic: @topic, user: @user)
      FactoryGirl.create(:target, lat: -34.91989494, lng: -56.16683006, radius: 1000, user: @user)
      @params = {
          lat:        -34.91989494,
          lng:        -56.16974831,
          radius:     1000,
          topic_id:      @topic.id
        }
    end

    context 'with valid params' do
      it 'should change the amunt of Targets' do
        expect { post :create, user_id: @user.id, target: @params , format: 'json' }.to change { Target.count }.by(1)
      end

      it 'should return the target json. and near_target' do
        post :create,  user_id: @user.id, target: @params , format: 'json'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['target']['latitude']).to          eq -34.91989494
        expect(parsed_response['target']['longitude']).to         eq -56.16974831
        expect(parsed_response['target']['radius']).to            eq 1000
        expect(parsed_response['target']['topic']).to             eq @topic.label
        expect(parsed_response['matches'].count).to               eq 1
      end
    end

    context 'with max limit' do
       it 'should not allows to create more than 10 Targets for each user' do
          @user_2 = FactoryGirl.create(:user)
          FactoryGirl.create_list(:target,10, user: @user_2)
          request.headers['X-USER-TOKEN'] =  @user_2.authentication_token
          post :create, user_id: @user_2.id, target: @params , format: 'json'
          expect(response.status).to eq 400
      end
    end

    context 'with invalid params' do
      context 'with empty params' do
        before :each do
          @params_invalid = {
            lat:  -34.91989494,
          }
        end

        it 'should not change the amunt of Targets' do
          expect { post :create, user_id: @user.id, target: @params_invalid , format: 'json' }.not_to change { Target.count }
        end

        it 'should send error status' do
          post :create, user_id: @user.id, target: @params_invalid , format: 'json'
          expect(response.status).to eq 400
        end
      end

      context 'with invalid params' do
        before :each do
          @params = {at: 'invalid', lng: -56.16974831, radius: 1000}
        end

        it 'should not change the amunt of Targets' do
          expect { post :create, user_id: @user.id, target: @params , format: 'json' }.not_to change { Target.count }
        end

        it 'should send error status' do
          post :create, user_id: @user.id, target: @params , format: 'json'
          expect(response.status).to eq 400
        end
      end
    end
  end 

  describe 'PUT Update' do
    before :each do
      @topic = FactoryGirl.create(:topic)
      @target = FactoryGirl.create(:target, 
        lat: -30.91989494, 
        lng: -50.16974831, 
        radius: 1000, 
        topic: @topic, 
        user: @user)
      @near_target = FactoryGirl.create(:target, lat: -34.91831144 ,lng: -56.16657257 ,radius: 1000 , topic: @topic)
      FactoryGirl.create(:target, lat: -34.60400053, lng: -58.37508202, radius: 1000, topic: @topic, user: @user)
      FactoryGirl.create(:target, lat: -34.91989494, lng: -56.16683006, radius: 1000, user: @user)
      @params = {
        lat:        -34.91831144,
        lng:        -56.16657257,
        radius:     1000,
        topic_id:      @topic.id
      }
    end

    context 'with valid params' do
      it 'should not change the amunt of Targets' do
        expect { put :update, 
          user_id: @user.id, 
          id: @target.id, 
          target: @params, 
          format: 'json' }.not_to change { Target.count }
      end

      it 'should return the updated target json. and near_target' do
        put :update, user_id: @user.id, id: @target.id, target: @params , format: 'json'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['target']['latitude']).to          eq -34.91831144
        expect(parsed_response['target']['longitude']).to         eq -56.16657257
        expect(parsed_response['target']['radius']).to            eq 1000
        expect(parsed_response['target']['topic']).to             eq @topic.label
        expect(parsed_response['matches'].count).to               eq 1
      end
    end

    context 'with valid params' do
      it 'should remove the Target' do
         @target = FactoryGirl.create(:target, user: @user)
         expect { delete :destroy, 
          user_id: @user.id, 
          id: @target.id, format: 'json' }.to change { Target.count }.by(-1)
      end
    end 

    context 'with invalid params' do
      it 'should remove the Target' do
        @target = FactoryGirl.create(:target)
        delete :destroy, user_id: @user.id, id: @target.id, format: 'json' 
        expect(response.status).to eq 400
      end
    end 
  end
end
