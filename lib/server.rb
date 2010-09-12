require File.join File.dirname(__FILE__), '../config/environment'

EventMachine.run do
  @channels = {}

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen do
        channel_id = ws.request['Path'].split('/').last
        channel = @channels[channel_id] ||= EM::Channel.new

        socket_id = channel.subscribe { |msg| ws.send msg }
        puts "open: channel #{channel_id}, socket #{socket_id}"

        ws.onmessage do |msg|
          event, data = JSON.parse(msg)

          case event
            when 'guess'
              channel.push msg
            when 'draw'
              data['paths'] = data.delete('path[]').map{|path| path.split(',')} if data['path[]']
              channel.push [event, data].to_json
          end
        end

        ws.onclose do
          channel.unsubscribe(socket_id)
          puts "close: channel #{channel_id}, socket #{socket_id}"
        end

      end
  end
end
