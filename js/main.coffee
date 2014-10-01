buildBoard = ->
  # board = []
  # for row in [0..3]
  #   board[row] = []
  #   for column in [0..3]
  #     board[row][column] = 0
  # board
  [0..3].map (-> [0..3].map (-> 0))

generateTile = ->
  console.log "generate tile"

printArray = (array) ->
  console.log "-- Start --"
  for row in array
    console.log row
  console.log "--  End  --"

$ ->
  newBoard = buildBoard()
  printArray(newBoard)
  generateTile()
  generateTile()