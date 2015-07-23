# encoding: utf-8

module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::Authenticable

      layout false
      respond_to :json

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActionController::RoutingError,      with: :render_not_found
      rescue_from ActionController::UnknownController, with: :render_not_found
      rescue_from AbstractController::ActionNotFound,  with: :render_not_found
      rescue_from PermissionsHelper::ForbiddenAccess,  with: :render_forbidden_access

      def status
        render json: { online: true }
      end

      def render_forbidden_access(exception)
        logger.info(exception) # for logging
        render json: { error: 'Not Authorized' }, status: :forbidden
      end

      def render_not_found(exception)
        logger.info(exception) # for logging
        render json: { error: exception.message }, status: :not_found
      end
    end
  end
end
