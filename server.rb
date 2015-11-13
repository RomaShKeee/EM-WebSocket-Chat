require 'eventmachine'
require 'em-websocket'
require 'json'

class ChatConnection < EventMachine::WebSocket::Connection
  attr_accessor :name
  def initialize(opts={})
    super
    onopen { on_open }
    onmessage { |message| on_message(message) }
    onclose { on_close}
  end

  def on_open
    #Chat.add_connection self
  end

  def on_message(message)
    if name
      Chat.send_message_to_all message, self
    else
      self.name = message
      Chat.add_connection self
    end
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
    send_message_to_all 'has joined', connection
  end

  def delete_connection(connection)
    CONNECTION.delete connection
    send_message_to_all 'has left chat', connection
  end

  def send_message_to_all(message, connection = nil)
    CONNECTION.each do |connect|
      if connection
        msg = { username: connection.name, message: message }
        connect.send msg.to_json
      else
        connect.send message
      end
    end
  end
end

EM.run do
  EM.start_server '0.0.0.0', '3000', ChatConnection
end
