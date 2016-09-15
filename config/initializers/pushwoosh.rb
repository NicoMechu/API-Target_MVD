Pushwoosh.configure do |config|
  config.application = ENV['PUSHWOOSH_APPLICATION']
  config.auth = ENV['PUSHWOOSH_AUTH']
end
