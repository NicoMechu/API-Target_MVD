# encoding: utf-8

module Api
  module V1
    class TopicsController < Api::V1::ApiController

      def index 
        @Topics = Topic.all
      end
    end
  end
end
