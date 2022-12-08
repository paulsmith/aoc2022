import math
import std/sequtils
import std/sugar

var lines = stdin.lines.toSeq

type
    Grid = seq[seq[int]]

proc parseInput(): Grid =
    var grid: Grid
    for line in lines:
        grid.add(line.toSeq.mapIt(ord(it) - ord('0')))
    result = grid

proc visible(grid: Grid, x: int, y: int): bool =
    assert grid.len > 0
    let h = grid.len
    let w = grid[0].len
    let this = grid[y][x]
    # short circuit - an edge is always visible
    if x == 0 or y == 0 or x == w-1 or y == h-1: return true
    # top down
    if (0..<y).allIt(grid[it][x] < this): return true
    # left right
    if (0..<x).allIt(grid[y][it] < this): return true
    # bottom up
    if (y+1..<h).allIt(grid[it][x] < this): return true
    # right left
    if (x+1..<w).allIt(grid[y][it] < this): return true
    result = false

proc debugPrint(grid: Grid) =
    for y in 0..<grid.len:
        for x in 0..<grid[y].len:
            stdout.write if grid.visible(x, y): 'T' else: 'F'
        echo ""

proc score(grid: Grid, x: int, y: int): int =
    assert grid.len > 0
    let h = grid.len
    let w = grid[0].len
    let this = grid[y][x]
    var dirs: array[4, int]
    # short-circuit: edge will always have zero scenic score
    if x == 0 or y == 0 or x == w-1 or y == h-1:
        return 0
    # up
    for yy in countdown(y-1, 0):
        dirs[0] += 1
        if grid[yy][x] >= this:
            break
    # left
    for xx in countdown(x-1, 0):
        dirs[1] += 1
        if grid[y][xx] >= this:
            break
    # down
    for yy in y+1..<h:
        dirs[2] += 1
        if grid[yy][x] >= this:
            break
    # right
    for xx in x+1..<w:
        dirs[3] += 1
        if grid[y][xx] >= this:
            break
    result = dirs.foldl(a * b)

proc part1(grid: Grid) =
    var total: int
    for y in 0..<grid.len:
        for x in 0..<grid[y].len:
            if grid.visible(x, y):
                total += 1
    echo total

proc part2(grid: Grid) =
    var highest: int
    for y in 0..<grid.len:
        for x in 0..<grid[y].len:
             let s = grid.score(x, y)
             if s > highest:
                 highest = s
    echo highest

let grid = parseInput()
part1(grid)
part2(grid)
