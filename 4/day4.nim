import strutils
import std/sequtils

proc parseLine(line: string): seq[seq[int]] =
    line.split({','}).mapIt(it.split({'-'}).mapIt(it.parseInt))

proc fullyContains(pair: seq[seq[int]]): bool =
    let
        a = pair[0]
        b = pair[1]
    (a[0] >= b[0] and a[1] <= b[1]) or (b[0] >= a[0] and b[1] <= a[1])

proc overlaps(pair: seq[seq[int]]): bool =
    let
        a = pair[0]
        b = pair[1]
    not (a[1] < b[0] or b[1] < a[0])

var lines = stdin.lines.toSeq

proc part1() =
    echo lines.mapIt(parseLine(it)).countIt(fullyContains(it))

proc part2() =
    echo lines.mapIt(parseLine(it)).countIt(overlaps(it))

part1()
part2()
