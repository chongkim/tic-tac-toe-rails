boat_duration = 60000
boat_rocking_duration = 3000
loading = false
animate = true

animate_boat_right = ->
  $('#boat').attr('src', '/assets/boat-flip.png')
  $('#boat').animate({left: '100%'}, boat_duration, animate_boat_left)

animate_boat_left = ->
  $('#boat').attr('src', '/assets/boat.png')
  $('#boat').animate({left: '-300px'}, boat_duration, animate_boat_right)

animate_boat_clockwise = ->
  $('#boat').rotate({
    animateTo: 10
    duration: boat_rocking_duration
    easing: (x, t, b, c, d) -> return b+(t/d)*c
    callback: animate_boat_counterclockwise})
animate_boat_counterclockwise = ->
  $('#boat').rotate({
    animateTo: -10
    duration: boat_rocking_duration
    easing: (x, t, b, c, d) -> return b+(t/d)*c
    callback: animate_boat_clockwise })
animate_loading = ->
  $("#loading img").rotate({
    angle: 0,
    animateTo: 360,
    duration: 4000,
    easing: (x, t, b, c, d) -> return b+(t/d)*c
    callback: -> animate_loading
  })

$ ->
  $('#ttt').html($('#set_first_player').html())
  if animate
    animate_boat_left()
    animate_boat_clockwise()
  $.ajaxSetup({
    beforeSend: ->
      loading = true
      setTimeout(
        ->
          if (loading)
            $('#loading').show()
            animate_loading()
      , 500)
    complete: ->
      loading = false
      $('#loading').hide()
  })
  $('#options').buttonset()
  

root = exports ? this
first_player = {}
second_player = {}
current_player = {}
dim = 3
root.game_end = false
root.current_player_symbol = null
root.init_position = (board="- - -"+
                            "- - -"+
                            "- - -", turn="x") ->
  position =
    board: (x for x in board when x in "xo-")
    turn: turn
  position

root.position = init_position()

root.win_lines = ->
  arr = [0..(dim*dim-1)]
  res = []
  for i in [0..2]
    res.push (e for e in arr when Math.floor(e / dim) == i)
  for i in [0..2]
    res.push (e for e in arr when e % dim == i)
  res.push (i for i in [0..(dim*dim-1)] by (dim+1))
  res.push (i for i in [(dim-1)..(dim*dim-dim)] by (dim-1))
  res

root.is_win = (turn) ->
  for line in win_lines()
    return true if is_win_line(line, turn)
  return false

root.is_win_line = (line, turn) ->
  for i in line
    return false if root.position.board[i] != turn
  return true

root.count_blanks = ->
  sum = 0
  sum += 1 for e in root.position.board when e == "-"
  sum

root.clear_board = ->
  for i in [0..(dim*dim-1)]
    $("#t-#{i}").html("")

root.play_again = ->
  root.position = init_position()
  clear_board()
  root.game_end = false
  computer_move() if first_player.name == "Computer"

root.ask_play_again = (title, body) ->
  if playing_computer()
    $('#play_again_dialog').dialog(
      autoOpen: true
      resizable: false
      modal: true
      buttons:
        'Yes': ->
          play_again()
          $(this).dialog('close')
        'No': ->
          $('#message').html($('#message').html() + "<button onclick='javascript:play_again()'>Play again</button>")
          $(this).dialog('close'))
  else
    $('#play_again_dialog').dialog(
      autoOpen: true
      resizable: false
      title: title
      modal: true
      buttons:
        'Ok': ->
          $(this).dialog('close'))

root.end_game = () ->
  root.game_end = true
  setTimeout(ask_play_again, 500)

root.playing_computer = -> return (first_player.name == "Computer" || second_player.name == "Computer")

root.set_winner = (winner) ->
  if winner
    $('#message').html("#{winner} Wins")
    html = "#{winner} Wins."
    html += "  Do you want to play again?" if playing_computer()
    $('#play_again_dialog').html(html)
  else
    $("#message").html("Game is a draw")
    html = "Draw."
    html += "  Do you want to play again?" if playing_computer()
    $('#play_again_dialog').html(html)

root.check_for_win = ->
  if (is_win("x"))
    set_winner(first_player.name)
    end_game()
  else if (is_win("o"))
    set_winner(second_player.name)
    end_game()
  else if count_blanks() == 0
    set_winner(null)
    end_game()
  
root.set_players = (first_player_in, second_player_in, current_player_in, player_symbol) ->
  first_player  = first_player_in
  second_player = second_player_in
  current_player = current_player_in
  $('#ttt').html($('#board_display').html())
  $('#message').html("Welcome to Tic Tac Toe")
  root.current_player_symbol = player_symbol
  computer_move() if first_player.name == "Computer"
  $('#first_player').addClass('turn')
  check_for_move() if root.current_player_symbol != "x"

root.make_mark = (symbol) ->
  return "" if symbol == "-"
  "<img src=\"/assets/#{if symbol == "x" then "oars" else "lifepreserver"}.png\">"

root.put_mark = (idx, symbol) ->
  html = $('#t-'+idx).html()
  if html != make_mark(symbol)
    $('#t-'+ idx).html(make_mark(symbol))
root.get_mark = (idx) -> $('#t-'+idx).html()

clear_message = () -> $('#message').html("")

root.other_turn = (turn) -> if turn == "x" then "o" else "x"

root.put_turn = ->
  if position.turn == "x"
    $("#first_player").addClass("turn")
    $("#second_player").removeClass("turn")
  else
    $("#first_player").removeClass("turn")
    $("#second_player").addClass("turn")


root.make_move = (idx, symbol) ->
  return false if root.game_end
  return false if symbol != root.position.turn
  return false if current_player.email != first_player.email && current_player.email != second_player.email
  clear_message()
  if (root.position.board[idx] == "-")
    put_mark(idx, root.position.turn)
    root.position.board[idx] = root.position.turn
    root.position.turn = other_turn(root.position.turn)
    put_turn()
    check_for_win()
    return true
  else
    $('#message').html("Please click on an empty square")
    return false

root.computer_move = () ->
  return if root.game_end
  root.position.speed = $('input[name="speed"]:checked').attr('id')
  $.get("/ttt/move", root.position, (n) -> make_move(n, other_turn(current_player_symbol)))

root.opponent_move = ->
  return if root.game_end
  $.get("/games/"+root.game_id+"/opponent_move", root.position, check_for_move)

root.set_position = (new_position) ->
  return if new_position == null
  root.position = new_position
  put_mark(idx, root.position.board[idx]) for idx in [0..8]
  put_turn()
  check_for_win()

root.get_position = -> $.get("/games/"+root.game_id+"/get_position", set_position)

root.check_for_move = ->
  return if root.game_end
  get_position()
  if position.turn != current_player_symbol
    setTimeout(check_for_move, 3000)

root.send_move = (n, symbol) ->
  return if root.game_end
  if make_move(n, symbol)
    if playing_computer()
      computer_move()
    else
      opponent_move()
