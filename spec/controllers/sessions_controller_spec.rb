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
        email:            @user.email,
        password:         'mypass123',
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

    let(:fb_access_token )  { '1234567890_VALID'}
    let(:name)              { 'Test test' }
    let(:email)             { 'test2@api_base.com' }
    let!(:user)             { create(:user, facebook_id: '1234567890', name:name, email: email) }

    context 'with valid params' do
      context 'when the user does not exist' do
        it 'creates a new facebook user' do
          expect { post :create, { type: 'facebook', fb_access_token:  '1111111111_VALID' }, format: 'json' }.to change { User.count }.by(1)
        end

        it 'creates a user with the correct information' do
          post :create, { type: 'facebook', fb_access_token:  fb_access_token}, format: 'json'
          fb_user = User.find_by(facebook_id: 1234567890 ,  name:name, email: email)
          expect(fb_user).to_not be_nil
          expect(JSON.parse(response.body)['token']).to eq(fb_user.authentication_token)
        end

        it 'returns a successful response' do
          post :create, { type: 'facebook', fb_access_token:  fb_access_token }, format: 'json'
          expect(response.response_code).to eq(200)
        end  
      end

      context 'when the user exists' do
        let!(:user)       { create(:user_with_fb, facebook_id: 1234567890) }

        it 'does not create a new user record' do
          expect { post :create, {type: 'facebook', fb_access_token:  fb_access_token }, format: :json }.not_to change { User.count }
        end
      end
    end

    context 'with invalid params' do
      context 'when the data is empty' do
        it 'does not create a user' do
           post :create, {  type: 'facebook'}, format: 'json' 
           expect(response.status).to eq(403)
        end
      end

      context 'when the data is incorrect' do
        it 'does not create a user' do 
          post :create, {  type: 'facebook', invalid_param:  fb_access_token  }, format: 'json' 
          expect(response.status).to eq(403)
        end
      end

      context 'when the authentication is invalid'  do
        context 'the authentication token is invalid' do
          let(:fb_access_token )  { '1234567890_INVALID'}
          it 'rais 401 error' do
            post :create, {type: 'facebook', fb_access_token:  fb_access_token  }, format: 'json'
            expect(response.status).to eq(403)
          end
        end
      end
    end
  end
end
