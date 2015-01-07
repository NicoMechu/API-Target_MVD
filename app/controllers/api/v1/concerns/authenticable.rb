module Api
  module V1
    module Concerns
      module Authenticable
        extend ActiveSupport::Concern
        included do
          before_action :authenticate_user_token, unless: :non_authenticable_methods
        end

        def authenticate_user_token
          if current_user.blank?
            render json: { errors: ['You need to provide a valid token and email/fb'] }, status: :unauthorized
          end
        end

        # TODO, rethink this and evaluate to move this to independent
        # skip_before_action callbacks on individual controllers

        def non_authenticable_methods
          request.method == 'OPTIONS' ||
          non_authenticable_devise_methods ||
          non_authenticable_api_methods ||
          (controller_name == 'users' && (action_name == 'facebook_login'))
        end

        def non_authenticable_api_methods
          controller_name == 'api' && action_name == 'status'
        end

        def non_authenticable_devise_methods
          non_authenticable_sessions || non_authenticable_registrations || non_authenticable_passwords
        end

        def non_authenticable_sessions
          devise_controller? && controller_name == 'sessions' &&
          (action_name == 'create' || action_name == 'failure')
        end

        def non_authenticable_registrations
          (devise_controller? && controller_name == 'registrations' && action_name == 'create')
        end

        def non_authenticable_passwords
          (devise_controller? && controller_name == 'passwords' && (action_name == 'create' || action_name == 'update'))
        end
      end
    end
  end
end
