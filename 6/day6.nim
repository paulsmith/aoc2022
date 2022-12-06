import std/algorithm
import std/setutils

template processSignal(size: typed) =
    var buf: array[size, char]
    for i, ch in input:
        buf.rotateLeft(1)
        buf[^1] = ch
        if i >= size:
            if buf.toSet.card == size:
                echo i+1
                break

proc part1(input: string) =
    processSignal(4)

proc part2(input: string) =
    processSignal(14)

let input = readAll(stdin)

part1(input)
part2(input)
