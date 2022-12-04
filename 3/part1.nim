import std/setutils

var tally: int = 0
for line in stdin.lines:
    var comp1 = line[0..(line.len div 2)-1].toSet
    var comp2 = line[(line.len div 2)..line.len-1].toSet
    let common = comp1 * comp2
    if common.card != 1:
        raise newException(Exception, "expected exactly 1")
    var priority: int
    for ch in common:
        priority = if ch >= 'a' and ch <= 'z':
            ord(ch) - ord('a') + 1
        elif ch >= 'A' and ch <= 'Z':
            ord(ch) - ord('A') + 27
        else:
            raise newException(Exception, "unknown char")
        break
    tally += priority
echo tally
