$ ->
  client = new WebSocket("ws://localhost:3000")
  client.onopen = ->
    console.log("Connected")

  $("#chat_input").keyup (e) ->
    if e.keyCode == 13
      message = $('#chat_input').val()
      client.send message
      $('#chat_input').val ''
