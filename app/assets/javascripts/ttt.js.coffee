$ -> $('#ttt').html($('#set_first_player').html())
$ -> $('#play_again_dialog').dialog(
  autoOpen: false
  resizable: false
  height: 240
  modal: true
  buttons:
    'Yes': ->
      play_again()
      $(this).dialog('close')
    'No': -> $(this).dialog('close'))

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

root.ask_play_again = ->
  $('#play_again_dialog').dialog('open')

root.end_game = () ->
  root.game_end = true
  setTimeout(ask_play_again, 250)

root.check_for_win = ->
  if (is_win("x"))
    $("#message").html("#{first_player} Wins")
    end_game()
  else if (is_win("o"))
    $("#message").html("#{second_player} Wins")
    end_game()
  else if count_blanks() == 0
    $("#message").html("Game is a draw")
    end_game()

root.set_first_player = (player) ->
  first_player = player
  second_player = if player == "Computer" then "Human" else "Computer"
  $('#ttt').html($('#board_display').html())
  $('#message').html("Welcome to Tic Tac Toe")
  computer_move() if (player == "Computer")

root.computer_move = () ->
  return if root.game_end
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
  else
    $('#message').html("Please click on an empty square")

root.send_move = (n) ->
  return if root.game_end
  make_move(n)
  computer_move()
