# encoding: utf-8

module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_filter :verify_authenticity_token, if: :json_request?

      # POST /resource/sign_in
      def create
        if params[:type] == 'facebook' #TODO Verify correctness
          facebook_authorization( params[:user][:facebook_id] , params[:user][:fb_access_token]) 
          resource = User.find_or_create_by_fb(params[:user])   
        else
          resource = warden.authenticate! scope: resource_name, recall: "#{controller_path}#failure"
        end
        sign_in_and_redirect(resource_name, resource)
      end

      def sign_in_and_redirect(resource_or_scope, resource = nil)
        scope = Devise::Mapping.find_scope! resource_or_scope
        resource ||= resource_or_scope
        sign_in(scope, resource) unless warden.user(scope) == resource
        render json: { token: resource.authentication_token, email: resource.email }
      end

      # DELETE /resource/sign_out
      def destroy
        # expire auth token
        current_user.invalidate_token
        head :no_content
      end

      def failure
        render json: { errors: ['Login failed.'] }, status: :bad_request
      end

      private

      def user_params
        params.require(:user).permit(
          :username, :first_name,
          :last_name, :birth_year, :facebook_id, :email,
          :welcome_screen, :how_to_trade,
          :notifications
        )
      end

      protected

      def json_request?
        request.format.json?
      end

      def facebook_authorization(facebook_id, access_token)
          res = Faraday.get 'https://graph.facebook.com/me' , { :access_token => access_token}
          error!('401 Unauthorized', 401) if res.status != 200
          res_fb_id = JSON.parse(res.body)['id']
          error!('401 Unauthorized', 401) if res_fb_id != facebook_id
      end
    end
  end
end
