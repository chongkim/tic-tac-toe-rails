boat_duration = 80000
loading = false
animate_boat_right = ->
  $('#boat').attr('src', '/assets/boat-flip.png')
  $('#boat').animate({left: '100%'}, boat_duration, animate_boat_left)

animate_boat_left = ->
  $('#boat').attr('src', '/assets/boat.png')
  $('#boat').animate({left: '-300px'}, boat_duration, animate_boat_right)

animate_boat_clockwise = ->
  $('#boat').rotate({
    animateTo: 10,
    duration: boat_duration/5,
    easing: (x, t, b, c, d) -> return b+(t/d)*c,
    callback: animate_boat_counterclockwise})
animate_boat_counterclockwise = ->
  $('#boat').rotate({
    animateTo: -10,
    duration: boat_duration/5,
    easing: (x, t, b, c, d) -> return b+(t/d)*c,
    callback: ->
      animate_boat_clockwise if loading
  })
animate_loading = ->
  $("#loading img").rotate({
    angle: 0,
    animateTo: 360
    duration: 4000
    easing: (x, t, b, c, d) -> return b+(t/d)*c
    callback: -> animate_loading
  })

$ ->
  $('#ttt').html($('#set_first_player').html())
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
first_player = null
second_player = null
dim = 3
root.game_end = false
root.init_position = (board="- - -"+
                            "- - -"+
                            "- - -", turn="x") ->
  position =
    board: (x for x in board when x in "xo-")
    turn: turn
    x: "x"
    o: "o"
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
    return true if is_win_line line, turn
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
  $('#ttt').html($('#set_first_player').html())
  root.game_end = false

root.ask_play_again = (title, body) ->
  $('#play_again_dialog').html(body)
  $('#play_again_dialog').dialog(
    autoOpen: true
    resizable: false
    title: title
    modal: true
    buttons:
      'Yes': ->
        play_again()
        $(this).dialog('close')
      'No': ->
        $('#message').html($('#message').html() + "<button onclick='javascript:play_again()'>Play again</button>")
        $(this).dialog('close'))

root.end_game = () ->
  root.game_end = true
  setTimeout(ask_play_again, 250)

root.set_winner = (winner) ->
  if winner
    $('#message').html("#{winner} Wins")
    $('#play_again_dialog').html("#{winner} Wins. Do you want to play again?")
  else
    $("#message").html("Game is a draw")
    $('#play_again_dialog').html("Draw. Do you want to play again?")

root.check_for_win = ->
  if (is_win("x"))
    set_winner(first_player)
    end_game()
  else if (is_win("o"))
    set_winner(second_player)
    end_game()
  else if count_blanks() == 0
    set_winner(null)
    end_game()
  

root.set_first_player = (player) ->
  first_player = player
  second_player = if player == "Computer" then "Human" else "Computer"
  $('#ttt').html($('#board_display').html())
  $('#message').html("Welcome to Tic Tac Toe")
  computer_move() if (player == "Computer")

root.computer_move = () ->
  return if root.game_end
  root.position.speed = $('input[name="speed"]:checked').attr('id')
  $.get("/ttt/move", root.position, (n) -> make_move(n))

root.make_mark = (position) ->
  "<img src=\"/assets/#{if position.turn == position.x then "oars.png" else "lifepreserver.png"}\">"

clear_message = () -> $('#message').html("")

root.make_move = (n) ->
  return if root.game_end
  clear_message()
  if (root.position.board[n] == "-")
    $("#t-" + n).html(make_mark(root.position))
    root.position.board[n] = root.position.turn
    root.position.turn = if root.position.turn == root.position.x then root.position.o else root.position.x
    check_for_win()
    return true
  else
    $('#message').html("Please click on an empty square")
    return false

root.send_move = (n) ->
  return if root.game_end
  if make_move(n)
    computer_move()
