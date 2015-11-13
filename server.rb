require 'eventmachine'
require 'em-websocket'

class ChatConnection < EventMachine::WebSocket::Connection
  def initialize(opts={})
    super
    onopen { on_open }
    onmessage { |message| on_message(message) }
    onclose { on_close}
  end

  def on_open
    Chat.add_connection self
  end

  def on_message(message)
    puts message
  end

  def on_close
    Chat.delete_connection self
  end
end

module Chat
  module_function

  CONNECTION = []
  def add_connection(connection)
    CONNECTION.push connection
    puts 'New connection opened'
  end

  def delete_connection(connection)
    CONNECTION.delete connection
    puts 'Connection closed'
  end
end

EM.run do
  EM.start_server '0.0.0.0', '3000', ChatConnection
end
