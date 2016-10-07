module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.all_matches
      end

      def show
        @match = current_user.all_matches.find_by_id(params[:id])
        unless @match
          render json: { error: "There isn't any matches with this ID."}, status: :bad_request and return 
        end
      end

      def close
        @match = current_user.all_matches.find_by_id(params[:match_conversation_id])
        unless @match
          render json: { error: "There isn't any match with this ID"}, status: :bad_request and return 
        end
        @match.close_chat(current_user)
        unless @match.save
          render json: { errors: @match.errors }, status: :bad_request and return 
        end
        @last_logout =  @match.user_a_id == current_user.id ? @match.last_logout_a : @match.last_logout_b
      end

      def destroy
        @match = current_user.all_matches.find_by_id(params[:id])
        unless @match
          render json: { error: "There isn't any match with this ID"}, status: :bad_request and return 
        end
        unless @match.invisible(current_user)
          render json: { errors: @match.errors }, status: :bad_request and return 
        end
      end
    end
  end
end
