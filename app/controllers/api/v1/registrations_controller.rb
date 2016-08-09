# encoding: utf-8

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: [:create]
      skip_before_filter :verify_authenticity_token, if: :json_request?


      def create
        facebook_authorization(params[:facebook_id], params[:fb_access_token]) if params.has_key?(:facebook_id) #TODO

        build_resource(sign_up_params)
        resource_saved = resource.save
        if resource_saved
          save_success
          render json: { token: resource.authentication_token, email: resource.email }
        else
          save_fail
          render json: { error: resource.errors }, status: :bad_request
        end
      end

      protected

      def save_success
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
        else
          expire_data_after_sign_in!
        end
      end

      def save_fail
        clean_up_passwords resource
        @validatable = devise_mapping.validatable?
        @minimum_password_length = resource_class.password_length.min if @validatable
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.for :sign_up do |params|
          params.permit(
            :username, :first_name, :last_name, :birth_year , :email, :password, :password_confirmation
          )
        end
      end

      def json_request?
        request.format.json?
      end

      def facebook_authorization(facebook_id, access_token)
        res = Faraday.get 'https://graph.facebook.com/me' , { :access_token => access_token }
        error!('401 Unauthorized', 401) if res.status != 200
        res_db_id = JSON.parse(res.body)['id']
        error!('401 Unauthorized', 401) if res_db_id != facebook_id
      end

    end
  end
end
