import sequtils
import strutils
import re

var lines = stdin.lines.toSeq

type
    Stack = seq[char]
    Command = tuple[count: int, fromPos: int, toPos: int]

proc parseInput(): tuple[stacks: seq[Stack], commands: seq[Command]] =
    let stackCount = (lines[0].len + 1) div 4
    var stacks = newSeq[Stack](stackCount)
    var n: int
    for line in lines:
        n += 1
        if line == "":
            break
        for i in 0..<stackCount:
            let ch = line[i * 4 + 1]
            if isUpperAscii(ch):
                stacks[i].insert(ch, 0)
    let expr = re"move (\d+) from (\d+) to (\d+)"
    var matches: array[3, string]
    var commands: seq[(int, int, int)]
    for line in lines[n..^1]:
        if line.find(expr, matches) >= 0:
            let m = matches.mapIt(it.parseInt)
            let count = m[0]
            let fromPos = m[1] - 1
            let toPos = m[2] - 1
            commands.add((count, fromPos, toPos))
        else:
            raise newException(Exception, "expected pattern match")
    result = (stacks, commands)

proc part1() =
    var (stacks, commands) = parseInput()
    for cmd in commands:
        for i in 0..<cmd.count:
            stacks[cmd.toPos].add(stacks[cmd.fromPos].pop())
    echo stacks.mapIt(it[^1]).join

proc part2() =
    var (stacks, commands) = parseInput()
    for cmd in commands:
        var tmp = newSeq[char](cmd.count)
        for i in 0..<cmd.count:
            tmp[cmd.count-1-i] = stacks[cmd.fromPos].pop()
        for i in 0..<cmd.count:
            stacks[cmd.toPos].add(tmp[i])
    echo stacks.mapIt(it[^1]).join

part1()
part2()
