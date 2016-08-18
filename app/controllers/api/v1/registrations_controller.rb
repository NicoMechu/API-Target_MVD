# encoding: utf-8

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: [:create]
      skip_before_filter :verify_authenticity_token, if: :json_request?

      def create
        user_params = sign_up_params
        user_params[:gender] = user_params[:gender].to_i if user_params[:gender].is_a? String
        build_resource(user_params)
        resource_saved = resource.save
        if resource_saved
          save_success
          render json: { token: resource.authentication_token, email: resource.email, name:resource.name, gender:resource.gender, user_id:resource.id  }
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
            :name, :gender , :email , :password, :password_confirmation
          )
        end
      end

      def json_request?
        request.format.json?
      end
    end
  end
end
