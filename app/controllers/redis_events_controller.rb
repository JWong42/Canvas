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
          #feed = data['notification']
          #feed_id = feed['id']
          #if current_user.unread_feed.nil?
            #UnreadFeed.create!(user_id: current_user.id, count: 1, list: [feed_id])
            #data['unread'] = true 
          #else
            #unread_feed = current_user.unread_feed
            #unread_feed_count = unread_feed.count + 1
            #unread_feed_list = unread_feed.list + [feed_id]
            #unread_feed.update_attributes!(user_id: current_user.id, count: unread_feed_count, list: unread_feed_list)
          #end 
          data['test'] = current_user.last_name
          data = data.to_json
          sse.write(data, event: 'feeds')
        end 
      end
    end
    render nothing: true 
  rescue IOError
    puts "IOError.\n"
    # When the client disconnects, we'll get an IOError on write
  ensure 
    puts "closed.\n"
    redis.quit
    sse.close
  end 
  
end
