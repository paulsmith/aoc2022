import std/sequtils
import strutils
import math
import algorithm

var lines = stdin.lines.toSeq

type
    Kind = enum
        file,
        directory
    Entry = ref object
        case kind: Kind
        of file:
            size: int
        of directory:
            entries: seq[Entry]
            parent: Entry
        name: string

proc printFs(fs: Entry, depth: int = 0) =
    assert fs.kind == directory
    for entry in fs.entries:
        case entry.kind:
        of directory:
            echo entry.name
            printFs(entry, depth+1)
        of file:
            echo "FILE: ", entry.name, " SIZE: ", entry.size

proc findDirsAtMost(fs: Entry, dirs: var seq[int]): int =
    assert fs.kind == directory
    var total: int
    for entry in fs.entries:
        case entry.kind:
        of directory:
            let size = findDirsAtMost(entry, dirs)
            if size <= 100000:
                dirs.add(size)
            total += size
        of file:
            total += entry.size
    result = total

proc calcAllDirSizes(fs: Entry, dirs: var seq[int]): int =
    assert fs.kind == directory
    var total: int
    for entry in fs.entries:
        case entry.kind:
        of directory:
            let size = calcAllDirSizes(entry, dirs)
            total += size
        of file:
            total += entry.size
    dirs.add(total)
    result = total

var root = Entry(kind: directory, name: "/")

proc parseInput() =
    var cwd = root
    var n: int
    while true:
        if n >= lines.len:
            break
        let line = lines[n]
        n += 1
        if line.startsWith("$ "):
            let rest = line[2..^1]
            case rest[0..<2]:
            of "cd":
                let arg = rest[3..^1]
                case arg:
                of "/":
                    cwd = root
                of "..":
                    cwd = cwd.parent
                else:
                    var found = false
                    for entry in cwd.entries:
                        if entry.name == arg and entry.kind == directory:
                            cwd = entry
                            found = true
                            break
                    if not found:
                        raise newException(Exception, "file not found")
            of "ls":
                while n < lines.len:
                    let line = lines[n]
                    if line.startsWith("$"):
                        break
                    let bits = line.split({' '})
                    let name = bits[1]
                    if bits[0] == "dir":
                        cwd.entries.add(Entry(kind: directory, name: name, parent: cwd))
                    else:
                        let size = bits[0].parseInt
                        cwd.entries.add(Entry(kind: file, name: name, size: size))
                    n += 1
            else:
                raise newException(Exception, "unknown")
    # printFs(root)

proc part1() =
    var dirs: seq[int] = @[]
    discard findDirsAtMost(root, dirs)
    echo dirs.sum

proc part2() =
    var dirs: seq[int] = @[]
    let used = calcAllDirSizes(root, dirs)
    let unused = 70000000 - used
    let needed = 30000000 - unused
    dirs.sort()
    for size in dirs:
        if size > needed:
            echo size
            break

parseInput()
part1()
part2()
