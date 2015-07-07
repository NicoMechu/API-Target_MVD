# encoding: utf-8

require 'spec_helper'

describe Api::V1::SessionsController do
  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'create' do
    before :each do
      @user = FactoryGirl.create(:user, password: 'mypass123')
      @params = {
        email:        @user.email,
        password:     'mypass123'
      }
    end

    context 'with valid login' do
      it 'should return the user json' do
        post :create, user: @params, format: 'json'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['token']).to_not be_nil
      end
    end

    context 'with invalid login' do
      it 'should return error with wrong password' do
        @params['password'] = 'baddPassword'
        post :create, user: @params, format: 'json'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq 'authentication error'
      end

      it 'should return error with wrong email' do
        @params['email'] = 'bademail@eaea.com'
        post :create, user: @params, format: 'json'
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['error']).to eq 'authentication error'
      end
    end
  end

  describe "POST 'facebook_login'" do
    before :each do
      @user = FactoryGirl.create(:user)
      @fb_user = FactoryGirl.create(:user_with_fb)
      @params = {
          facebook_id:    '1234567890',
          first_name:     'test',
          last_name:      'dude',
      }
    end

    context 'with valid params' do
      context 'when the user does not exists' do
        it 'should create a new facebook user' do
          expect { post :create, { type: 'facebook', user:  @params } , format: 'json' }.to change { User.count }.by(1)
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
          expect { post :create, user: @new_user, format: :json }.not_to change { User.count }
        end
      end
    end

    context 'with invalid params' do
      it 'should not create an user on empty data' do
        expect { post :create, user: {type: 'facebook'} , format: 'json' }.not_to change { User.count }
      end

      it 'should not create an user on bad data' do
        expect { post :create, user: { facebook_id: '', first_name: 'some', type: 'facebook' } , format: 'json' }.not_to change { User.count }
      end
    end
  end
end
