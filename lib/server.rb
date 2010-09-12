require File.join File.dirname(__FILE__), '../config/environment'

EventMachine.run do
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen do
        socket_id = @channel.subscribe { |msg| ws.send msg }
        puts "#{socket_id} open"

        ws.onmessage do |msg|
          json = JSON.parse msg
          case json[0]
            when 'guess'
              @channel.push msg
            when 'draw'
              json[1]['paths'] = json[1].delete('path[]').map{|path| path.split(',')} if json[1]['path[]']
              @channel.push json.to_json
          end
        end

        ws.onclose do
          @channel.unsubscribe(socket_id)
          puts "#{socket_id} closed"
        end

      end
  end
end
