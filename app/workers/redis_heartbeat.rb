# require boot & environment for the Rails app
require "./config/boot"
require "./config/environment"
require "clockwork"


class RedisHeartbeat
  include Sidekiq::Worker

  def perform
    redis = Redis.new
    redis.publish('feeds', 'thump')
    # log for sidekiq
    logger.info "Redis heartbeat." 
  end
end

module Clockwork
  handler do |job| 
    puts "Queueing job: #{job}"
  end

  every(1.minute, "Clear stale (client closed connection) threads from puma."){ RedisHeartbeat.perform_async }
end

