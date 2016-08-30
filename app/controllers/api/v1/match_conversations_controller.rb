module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.all_matches
      end

      def show
        @match = current_user.find_by_id(params[:match_conversation_id])
      end
    end
  end
end
