# encoding: utf-8

module Api
  module V1
    class SessionsController < Devise::SessionsController
      include Concerns::Authenticable
      skip_before_filter :verify_signed_out_user 
      skip_before_filter :verify_authenticity_token, if: :json_request?
      before_action :invalidate_token, only:[:destroy]

      # POST /resource/sign_in
      def create
        if params[:type] == 'facebook'
          user = obtain_facebook_user(params[:fb_access_token])
          render json: { errors: 'Not Authorized' }, status: :forbidden and return if user.nil?
          return unless user

          user_params = {
            facebook_id: user['id'],
            gender:      user['gender'],
            email:       user['email'],
            name:        "#{user['first_name']} #{user['last_name']}",
            image:       facebook_picture(user)
          }
          resource = User.find_or_create_by_fb user_params
        else
          resource = warden.authenticate! scope: resource_name, recall: "#{controller_path}#failure"
        end
        sign_in_and_redirect(resource_name, resource)
      end

      def sign_in_and_redirect(resource_or_scope, resource = nil)
        scope = Devise::Mapping.find_scope! resource_or_scope
        resource ||= resource_or_scope
        sign_in(scope, resource) unless warden.user(scope) == resource
        render json: { 
          token:    resource.authentication_token, 
          email:    resource.email, 
          user_id:  resource.id, 
          name:     resource.name,
          image:    resource.image.url
        }
      end

      # Before the action "Destroy" it invalidates the current_user's token
      def invalidate_token
        current_user.invalidate_token
      end

      def failure
        render json: { errors: ['Login failed.'] }, status: :bad_request
      end

      protected

      def json_request?
        request.format.json?
      end

      def obtain_facebook_user(fb_access_token)
        begin
          graph = Koala::Facebook::API.new(fb_access_token)
          graph.get_object("me?fields=first_name,last_name,email,gender,picture")
        rescue Koala::Facebook::AuthenticationError => ex
          return nil
        end
      end

      def facebook_picture(fb_response)
        return nil unless fb_response['picture']
        img = open(fb_response['picture']['data']['url'])
        "data:#{img.content_type};base64," + Base64.encode64(img.read)
      end
    end
  end
end
