# encoding: utf-8

module Api
  module V1
    class UsersController < Api::V1::ApiController
      # PUT /api/v1/users/:id
      def update
        if current_user.update(user_params)
          render json: current_user
        else
          render json: { errors: current_user.errors.as_json }, status: :bad_request
        end
      end

      def change_password
        unless current_user.valid_password?(user_password[:prev])
          render json: { errors: 'The password is incorrect'}, status: :bad_request and return  
        end
        
        unless user_password[:password] == user_password[:confirmation]
          render json: { errors: 'The password and confirmation must match'}, status: :bad_request and return 
        end

        current_user.password = user_password[:password]
        if current_user.save
          render json: {
            user_id: current_user.id, 
            name: current_user.name, 
            email: current_user.email,
            authentication_token: current_user.authentication_token
          }
        else
          render json: { errors: current_user.errors.as_json }, status: :bad_request
        end
      end

      def unread_conversations
        unread = current_user.all_matches.select{|m| m.unread(current_user).count > 0 }
        render json: { unread_matches: unread.count} and return
      end

      private

      def render_bad_request
        head :bad_request
      end

      def user_params
        params.require(:user).permit(:name, :email, :image)
      end

      def user_password
        params.require(:user).permit(:prev, :password, :confirmation)
      end
    end
  end
end
