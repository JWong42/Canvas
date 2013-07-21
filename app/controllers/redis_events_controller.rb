require 'streamer/sse'

class RedisEventsController < ApplicationController

  include ActionController::Live

  def events 
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Streamer::SSE.new(response.stream)
    redis = Redis.new
    redis.subscribe('feeds') do |on|
      on.message do |event, data| 
        sse.write(data, event: 'feeds')
      end
    end
    render nothing: true 
  rescue IOError
    # When the client disconnects, we'll get an IOError on write
  ensure 
    redis.quit
    sse.close
  end 
  
end
