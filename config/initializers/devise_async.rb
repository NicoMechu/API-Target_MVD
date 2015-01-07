# encoding: utf-8

# Supported options: :resque, :sidekiq, :delayed_job
Devise::Async.backend = :delayed_job
