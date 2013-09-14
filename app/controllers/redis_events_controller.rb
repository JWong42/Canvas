require 'streamer/sse'

class RedisEventsController < ApplicationController

  include ActionController::Live

  def events 
    response.headers['Content-Type'] = 'text/event-stream'
    sse = Streamer::SSE.new(response.stream)
    redis = Redis.new
    redis.subscribe('feeds') do |on|
      on.message do |event, data| 
        data = JSON.parse(data)
        emails = data['emails']
        if emails.include?(current_user.email) 
          data = data.to_json
          sse.write(data, event: 'feeds')
        end 
      end
    end
    render nothing: true 
  rescue IOError
    puts "IOError."
    # When the client disconnects, we'll get an IOError on write
  ensure 
    redis.quit
    sse.close
  end 
  
end
