require File.join File.dirname(__FILE__), '../config/environment'

EventMachine.run {
  @channel = EM::Channel.new

  @lobbies = {}

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      # ws.onopen {
      #   puts "WebSocket connection open"
      # 
      #   # publish message to the client
      #   ws.send "Hello Client"
      # }
      # 
      # ws.onclose { puts "Connection closed" }
      # ws.onmessage { |msg|
      #   json = JSON.parse(msg)
      #   if(json['chat'])
      #     ws.send "CHAT: #{json['chat']}"
      #   end
      #   ws.send "Pong: #{msg}"
      # }
      ws.onopen {
        sid = @channel.subscribe { |msg| ws.send msg }
        #@channel.push "#{sid} connected!"

        ws.onmessage { |msg|
          json = JSON.parse msg
          case json['message_type']
            when 'guess'
              @channel.push msg
          end
          # @channel.push "<#{sid}>: #{msg}"
        }

        ws.onclose {
          @channel.unsubscribe(sid)
          #@channel.push "<#{sid}>: Disconnected"
        }

      }
  end
}
