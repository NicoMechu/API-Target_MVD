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
      request.headers['X-USER-EMAIL'] = @user.email
      put :update, id: @user.id, user: @attr, format: 'json'
      parsed_response = JSON.parse(response.body)
      @user.reload
      expect(response.response_code).to be 200
      expect(@user.username).to eq @attr[:username]
    end

    it 'should not allow to update an user (bad auth)' do
      @attr = { username: 'new username' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      request.headers['X-USER-EMAIL'] = 'bademail'
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(response.status).to eq 401
      expect(@user.username).to_not eq @attr[:username]
    end

    it 'should not allow to update an user (bad data)' do
      @attr = { email: 'notanemail' }
      request.headers['X-USER-TOKEN'] = @user.authentication_token
      request.headers['X-USER-EMAIL'] = @user.email
      put :update, id: @user.id, user: @attr, format: 'json'
      @user.reload
      expect(@user.username).to_not eq @attr[:username]
      expect(response.response_code).to eq 400
    end
  end

  describe "POST 'facebook_login'" do
    before :each do
      @user = FactoryGirl.create(:user)
      @fb_user = FactoryGirl.create(:user_with_fb)
      @params = {
        facebook_id:    '1234567890',
        first_name:     'test',
        last_name:      'dude'
      }
    end

    context 'with valid params' do
      context 'when the user does not exists' do
        it 'should create a new facebook user' do
          expect { post :facebook_login, user: @params , format: 'json' }.to change { User.count }.by(1)
          fb_user = User.find_by(facebook_id: @params[:facebook_id], first_name: @params[:first_name], last_name: @params[:last_name])
          expect(fb_user).to_not be_nil
          expect(response.response_code).to eq 200
          parsed_response = JSON.parse(response.body)
          expect(parsed_response['token']).to eq fb_user.authentication_token
        end
      end

      context 'when the user exists' do
        it 'should not create a new user record' do
          @new_user = { facebook_id: @fb_user.facebook_id, first_name: @fb_user.first_name, last_name: @fb_user.last_name }
          expect { post :facebook_login, user: @new_user, format: :json }.not_to change { User.count }
        end
      end
    end

    context 'with invalid params' do
      it 'should not create an user on empty data' do
        expect { post :facebook_login, user: {} , format: 'json' }.not_to change { User.count }
      end

      it 'should not create an user on bad data' do
        expect { post :facebook_login, user: { facebook_id: '', first_name: 'some' } , format: 'json' }.not_to change { User.count }
      end
    end
  end
end
