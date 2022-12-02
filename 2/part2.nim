import tables

type RPS = enum rock, paper, scissors

var lose = { rock: scissors, paper: rock, scissors: paper }.toTable
var win = { rock: paper, paper: scissors, scissors: rock }.toTable
var total: int = 0

for line in stdin.lines:
  let opp = case line[0]:
    of 'A': rock
    of 'B': paper
    of 'C': scissors
    else: raise newException(Exception, "unknown")
  case line[2]:
    of 'X': total += ord(lose[opp]) + 1
    of 'Y': total += ord(opp) + 1 + 3
    of 'Z': total += ord(win[opp]) + 1 + 6
    else: raise newException(Exception, "unknown")

echo "part 2: ", total
