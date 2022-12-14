import std/strutils,
  std/sequtils,
  std/sets,
  std/algorithm,
  std/heapqueue,
  sugar,
  tables

type
  Point = tuple[x: int, y: int]
  Grid = seq[seq[int]]

proc parseInput(input: string): (Grid, Point, Point) =
  var grid: Grid
  var startPoint, endPoint: Point
  for y, line in input.splitLines.toSeq:
    if line == "":
      break
    let row = collect:
      for x, ch in line:
        let height = if ch == 'S':
          startPoint = (x, y)
          'a'
        elif ch == 'E':
          endPoint = (x, y)
          'z'
        else:
          ch
        ord(height) - ord('a')
    grid.add row
  (grid, startPoint, endPoint)

proc neighbors(grid: Grid, pt: Point): seq[Point] =
  let h = grid.len
  let w = grid[0].len
  let dirs: array[4, Point] = [(0, -1), (0, 1), (-1, 0), (1, 0)]
  result = collect:
    for dir in dirs:
      let x = pt.x + dir.x
      let y = pt.y + dir.y
      if x >= 0 and x < w and y >= 0 and y < h:
        (x, y)

proc debugPrint(grid: Grid, cameFrom: Table[Point, Point], frontier: seq[Point]) =
  for y in 0..<grid.len:
    for x in 0..<grid[0].len:
      if frontier.contains((x, y)):
        stdout.write "\x1b[32m"
      stdout.write if cameFrom.hasKey((x, y)): '#' else: '.'
      stdout.write "\x1b[0m"
    echo ""
  echo ""

proc debugPrint(grid: Grid, path: seq[Point]) =
  for y in 0..<grid.len:
    for x in 0..<grid[0].len:
      if (x, y) in path:
        stdout.write "\x1b[32m#\x1b[0m"
      else:
        stdout.write "."
    echo ""
  echo ""

type
  HeightPoint = object
    point: Point
    height: int

proc `<`(a, b: HeightPoint): bool = a.height < b.height

proc cost(grid: Grid, a, b: Point): int =
  let aCost = grid[a.y][a.x]
  let bCost = grid[b.y][b.x]
  let cost = bCost - aCost
  if cost > 1:
    10000
  else:
    1

proc part1(grid: Grid, startPoint, endPoint: Point) =
  var frontier = initHeapQueue[HeightPoint]()
  frontier.push HeightPoint(point: startPoint, height: 0)
  var cameFrom = {startPoint: startPoint}.toTable
  var costSoFar = {startPoint: 0}.toTable
  #debugPrint(grid, cameFrom, frontier)
  while frontier.len > 0:
    let current = frontier.pop().point
    if current == endPoint:
      break
    for next in grid.neighbors(current):
      if grid.cost(current, next) > 1:
        continue
      let newCost = costSoFar[current] + grid.cost(current, next)
      if next notin costSoFar or newCost < costSoFar[next]:
        costSoFar[next] = newCost
        frontier.push HeightPoint(point: next, height: grid[next.y][next.x])
        cameFrom[next] = current
    #debugPrint(grid, cameFrom, frontier)
  var current = endPoint
  var path: seq[Point] = @[]
  while current != startPoint:
    path.add current
    current = cameFrom[current]
  path.add startPoint
  path.reverse
  debugPrint(grid, path)
  echo path.len-1

proc part2(grid: Grid, endPoint: Point) =
  let allAs = collect:
    for y in 0..<grid.len:
      for x in 0..<grid[0].len:
        if grid[y][x] == 0:
          (x, y)
  var allSteps: seq[int] = @[]
  for startPoint in allAs:
    var frontier = initHeapQueue[HeightPoint]()
    frontier.push HeightPoint(point: startPoint, height: 0)
    var cameFrom = {startPoint: startPoint}.toTable
    var costSoFar = {startPoint: 0}.toTable
    #debugPrint(grid, cameFrom, frontier)
    var found = false
    while frontier.len > 0:
      let current = frontier.pop().point
      if current == endPoint:
        found = true
        break
      for next in grid.neighbors(current):
        if grid.cost(current, next) > 1:
          continue
        let newCost = costSoFar[current] + grid.cost(current, next)
        if next notin costSoFar or newCost < costSoFar[next]:
          costSoFar[next] = newCost
          frontier.push HeightPoint(point: next, height: grid[next.y][next.x])
          cameFrom[next] = current
      #debugPrint(grid, cameFrom, frontier)
    if not found:
      continue
    var current = endPoint
    var path: seq[Point] = @[]
    while current != startPoint:
      path.add current
      current = cameFrom[current]
    path.add startPoint
    path.reverse
    #debugPrint(grid, path)
    allSteps.add path.len-1
  allSteps.sort
  echo allSteps[0]

let input = readAll(stdin)
let (grid, startPoint, endPoint) = parseInput(input)
part1(grid, startPoint, endPoint)
part2(grid, endPoint)
