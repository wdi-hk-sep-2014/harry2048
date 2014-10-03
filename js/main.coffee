randomInt = (x) ->
  Math.floor(Math.random() * x)

randomCellIndices = ->
  [randomInt(4), randomInt(4)]

randomValue = ->
  values = [2, 2, 2, 4]
  values[randomInt(4)]

buildBoard = ->
  # board = []
  # for row in [0..3]
  #   board[row] = []
  #   for column in [0..3]
  #     board[row][column] = 0
  # board
  [0..3].map (-> [0..3].map (-> 0))

generateTile = (board) ->
  value = randomValue()
  [row, column] = randomCellIndices()
  console.log "row: #{row} / col: #{column}"

  if board[row][column] is 0
    board[row][column] = value
  else
    console.log 'generate infinitely'
    generateTile(board)

  console.log "generate tile"

move = (board, direction) ->
  newBoard = buildBoard()

  for i in [0..3]
    if direction in ['right', 'left']
      row = getRow(i, board)
      row = mergeCells(row, direction)
      row = collapseCells(row, direction)
      setRow(row, i, newBoard)
    else if direction in ['down', 'up']
      column = getColumn(i, board)
      column = mergeCells(column, direction)
      column = collapseCells(column, direction)
      setColumn(column, i, newBoard)

  newBoard

getRow = (r, board) ->
  [board[r][0], board[r][1], board[r][2], board[r][3]]

getColumn = (c, board) ->
  [board[0][c], board[1][c], board[2][c], board[3][c]]

setRow = (row, index, board) ->
  board[index] = row

setColumn = (column, index, board) ->
  for i in [0..3]
    board[i][index] = column[i]

mergeCells = (cells, direction) ->

  merge = (cells) ->
    for a in [3...0]
      for b in [a-1..0]
        if cells[a] is 0 then break
        else if cells[a] == cells[b]
          cells[a] *= 2
          cells[b] = 0
          break
        else if cells[b] isnt 0 then break
    cells

  if direction in ['right', 'down']
    cells = merge(cells)
  else if direction in ['left', 'up']
    cells = merge(cells.reverse()).reverse()

  cells

# console.log mergeCells [2, 2, 0, 4], 'left'

collapseCells = (cells, direction) ->
  # Remove `0`
  cells = cells.filter (x) -> x isnt 0
  # Adding `0`
  while cells.length < 4
    if direction in ['right', 'down']
      cells.unshift 0
    else if direction in ['left', 'up']
      cells.push 0
  cells

# console.log collapseCells [0, 8, 0, 0], 'right'

moveIsValid = (originalBoard, newBoard) ->
  for row in [0..3]
    for col in [0..3]
      if originalBoard[row][col] isnt newBoard[row][col]
        return true

  false

boardIsFull = (board) ->
  for row in board
    if 0 in row
      return false
  true

noValidMoves = (board) ->
  for direction in ['up', 'down', 'left', 'right']
    newBoard = move(board, direction)
    if moveIsValid(board, newBoard)
      return false
  true

isGameOver = (board) ->
  boardIsFull(board) and noValidMoves(board)

showBoard = (board) ->
  for row in [0..3]
    for col in [0..3]
      $(".r#{row}.c#{col} img").remove()
      if board[row][col] is 0
        $(".r#{row}.c#{col} > div").html('')
        $(".r#{row}.c#{col}").css('background-color', 'rgba(238, 238, 218, 0.35)')
      else
        $(".r#{row}.c#{col} > div").html(board[row][col])
        powerOf2 = Math.log(board[row][col]) / Math.log(2)
        $(".r#{row}.c#{col}").css(
          'background-color',
          'rgba(40, 40, ' + (55 + Math.floor(200.0 * powerOf2 / 10.0)) + ', 1.0)'
        )
        for i in [1..powerOf2]
          harrys = [
            'http://t1.gstatic.com/images?q=tbn:ANd9GcRc85uYJ6eMK2o028Tsz3P6_qbjIA3psTM3rfrgnvBudrFVtSpG4w',
            'https://avatars0.githubusercontent.com/u/1784995?v=2&s=460',
            'https://ga-core.s3.amazonaws.com/production/uploads/instructor/image/2019/thumb_HarryNgSquare.png',
            'http://images.ak.instagram.com/profiles/profile_48755117_75sq_1335613485.jpg'
          ]
          harrySrc = harrys[Math.floor(Math.random() * harrys.length)]
          $(".r#{row}.c#{col}").append(
            $("<img src=\"#{harrySrc}\">")
              .css({width: 30, height: 30}))

printArray = (array) ->
  console.log "-- Start --"
  for row in array
    console.log row
  console.log "--  End  --"

$ ->
  @board = buildBoard()
  generateTile(@board)
  generateTile(@board)
  showBoard(@board)

  $('body').keydown (e) =>

    key = e.which
    keys = [37..40]

    if key in keys
      e.preventDefault()
      # continue the game
      console.log "key: ", key
      direction = switch key
        when 37 then 'left'
        when 38 then 'up'
        when 39 then 'right'
        when 40 then 'down'

      # try moving
      newBoard = move(@board, direction)
      printArray newBoard
      # check the move validity, by comparing the original and new board
      if moveIsValid(@board, newBoard)
        console.log "valid"
        @board = newBoard
        # generate tile
        generateTile(@board)
        # show board
        showBoard(@board)
        # check game lost
        if isGameOver(@board)
          console.log "YOU LOSE!"
      else
        console.log "invalid"

    else
      # do nothing





