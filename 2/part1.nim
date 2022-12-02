import tables

type RPS = enum rock, paper, scissors

var fight = {
  (rock, rock): 3,
  (rock, paper): 0,
  (rock, scissors): 6,
  (paper, paper): 3,
  (paper, rock): 6,
  (paper, scissors): 0,
  (scissors, paper): 6,
  (scissors, rock): 0,
  (scissors, scissors): 3,
}.toTable

var total: int = 0

for line in stdin.lines:
  let opp = case line[0]:
    of 'A': rock
    of 'B': paper
    of 'C': scissors
    else: raise newException(Exception, "unknown")
  let home = case line[2]:
    of 'X': rock
    of 'Y': paper
    of 'Z': scissors
    else: raise newException(Exception, "unknown")
  total += ord(home) + 1 + fight[(home, opp)]

echo "part 1: ", total
