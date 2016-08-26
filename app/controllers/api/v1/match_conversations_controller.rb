module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.all_matches
      end
    end
  end
end
