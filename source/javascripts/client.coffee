$ ->
  client = new WebSocket("ws://localhost:3000")
  client.onopen = ->
    console.log("Connected")
  client.onmessage = (message) ->
    json = JSON.parse(message.data)
    add_chat_message json


  $("#chat_input").keyup (e) ->
    if e.keyCode == 13
      message = $('#chat_input').val()
      client.send message
      $('#chat_input').val('').attr("placeholder", "Type message and press Enter")
  $chat_log = $("#chat_log")
  add_entry_to_log = (message) ->
    $chat_log.prepend "<div class=\"msg-body\"> #{message} </div>"
  add_chat_message = (json) ->
    add_entry_to_log "<b>#{json.username}:</b> #{json.message}"
