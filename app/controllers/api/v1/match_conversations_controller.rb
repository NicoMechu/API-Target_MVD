module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.all_matches
      end

      def show
        @match = current_user.all_matches.find_by_id(params[:match_conversation_id])
      end

      def close
        @match = current_user.all_matches.find_by_id(params[:match_conversation_id])
        @match.close_chat(current_user)
        unless @match.save
          render json: { errors: @match.errors }, status: :bad_request and return 
        end
        @last_logout =  @match.user_a_id == current_user.id ? @match.last_logout_a : @match.last_logout_b
      end
    end
  end
end
