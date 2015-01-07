module Api
  module V1
    module Concerns
      module Corsable
        extend ActiveSupport::Concern

        included do
          before_action :cors_set_access_control_headers
        end

        def cors_preflight_check
          if request.method == 'OPTIONS'
            response_headers['Access-Control-Allow-Origin'] = '*'
            response_headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
            response_headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version, X-User-Token'
            response_headers['Access-Control-Allow-Headers'] += ', X-User-Email, X-User-Facebook'
            response_headers['Access-Control-Max-Age'] = '1728000'
            render text: '', content_type: 'text/plain'
          end
        end

        private

        def response_headers
          request.headers
        end

        def cors_set_access_control_headers
          response_headers['Access-Control-Allow-Origin'] = '*'
          response_headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
          response_headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization'
          response_headers['Access-Control-Allow-Headers'] += ', X-User-Token, X-User-Email, X-User-Facebook'
          response_headers['Access-Control-Max-Age'] = '1728000'
        end
      end
    end
  end
end
