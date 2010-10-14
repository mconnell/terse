require File.join File.dirname(__FILE__), '../config/environment'

EventMachine.run do
  @lobbies = {}

  def find_or_create_lobby(lobby_id)
    @lobbies[lobby_id] || @lobbies[lobby_id] = Lobby.new(lobby_id)
  end

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen do
      lobby_id = ws.request['Path'].split('/').last
      lobby = find_or_create_lobby(lobby_id)

      socket_id = lobby.channel.subscribe { |msg| ws.send msg }
      puts "open: channel #{lobby_id}, socket #{socket_id}"

      # Receive Message
      ws.onmessage do |msg|
        event, data = JSON.parse(msg)

        case event
          when 'guess'
            if data['guess'] == lobby.game.word
              ws.send msg
            else
              lobby.channel.push msg
            end
          when 'draw'
            data['paths'] = data.delete('path[]').map{|path| path.split(',')} if data['path[]']
            lobby.channel.push [event, data].to_json
        end
      end

      # Closing connection
      # unsubscribe the user from the channel
      ws.onclose do
        lobby.channel.unsubscribe(socket_id)
        puts "close: lobby #{lobby_id}, socket #{socket_id}"
      end
    end
  end
end

#
# authenticate user on connection
# Path: /hashed_user_id/lobby_id
#
# If no authentication, disconnect the client.
