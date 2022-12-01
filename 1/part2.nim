import strutils
import std/algorithm
import math

var calories: seq[int]
var tally: int = 0

for line in stdin.lines:
    if line == "":
        calories.add(tally)
        tally = 0
    else:
         tally += parseInt(line)
calories.sort(Descending)
echo sum(calories[0..2])
