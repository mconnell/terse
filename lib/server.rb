require File.join File.dirname(__FILE__), '../config/environment'

EventMachine.run {
  @channel = EM::Channel.new

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
      ws.onopen {
        puts "connect"
        sid = @channel.subscribe { |msg| ws.send msg }

        #@channel.push "#{sid} connected!"

        ws.onmessage { |msg|
          json = JSON.parse msg
          case json[0]
            when 'guess'
              @channel.push msg
            when 'draw'
              json[1]['paths'] = json[1].delete('path[]').map{|path| path.split(',')} if json[1]['path[]']
              @channel.push json.to_json
          end
        }

        ws.onclose {
          puts "disconnect"
          @channel.unsubscribe(sid)
        }

      }
  end
}
