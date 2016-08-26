# encoding: utf-8

module Api
  module V1
    class PushTokensController < Api::V1::ApiController
      def create
        @push = PushToken.new(user:current_user, push_token: params[:push_token])
        render json: { errors: @push.errors }, status: :bad_request and return unless @push.save
      end
    end
  end
end
