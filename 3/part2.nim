import std/setutils

var tally = 0
while true:
    var line1, line2, line3: string
    if not stdin.readLine(line1): break
    if not stdin.readLine(line2): break
    if not stdin.readLine(line3): break
    let common = line1.toSet * line2.toSet * line3.toSet
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
