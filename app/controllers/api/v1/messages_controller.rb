module Api
  module V1
    class MessagesController < Api::V1::ApiController
      def create
        @match = current_user.all_matches.find_by_id(params[:match_conversation_id]) 
        unless @match
          render json: { errors:  "There aren't any Matches with this ID"}, status: :bad_request and return 
        end
        @message = Message.new(user: current_user, match_conversation: @match, text: message_params[:text])
        unless @message.save
          render json: { errors: @message.errors }, status: :bad_request and return 
        end
      end

      def index
        @match = current_user.all_matches.find_by_id(params[:match_conversation_id])
        unless @match
          render json: { errors: "There isn't any match with that ID." }, 
            status: :bad_request and return 
        end
        @messages = @match.messages.recent.page( params[:page] || 1 )
      end

      private
      def message_params
        params.require(:message).permit(:text)
      end
    end
  end
end
