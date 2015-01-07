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
end
