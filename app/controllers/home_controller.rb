class HomeController < ApplicationController
  def index
    head(:bad_request) && return unless iphone?

    url = params.delete(:url)
    params_str = params.to_param
    redirect_to "#{ENV['DEEPLINK']}#{url}?#{params_str}"
  end

  private

  def iphone?
    request.user_agent =~ /iPhone/i
  end
end
