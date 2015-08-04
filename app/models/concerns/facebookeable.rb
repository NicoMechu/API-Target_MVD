# encoding: utf-8

module Facebookeable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_by_fb(fb_data)
      fb_id = fb_data[:facebook_id]
      user = User.find_by(facebook_id: fb_id)
      if user.blank?
        user = User.create(
          facebook_id: fb_id,
          first_name: fb_data[:first_name],
          last_name: fb_data[:last_name],
          email: fb_data[:email]
        )
      end
      user
    end
  end

  def send_fb_notification(message)
    return unless facebook_id.present? && notifications
    oauth = Koala::Facebook::OAuth.new(ENV['FB_ID'], ENV['FB_SECRET'])
    oauth_token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(oauth_token)
    graph.put_connections(facebook_id, 'notifications', template: message)
  end
end
