import std/strutils
import std/sequtils
import std/algorithm
import strformat
import math

type
  Operand = enum
    Old, Num
  Operator = enum
    Mul, Add
  Operation = object
    operator: Operator
    case operand: Operand
    of Old: nil
    of Num: value: int
  Monkey = object
    items: seq[uint64]
    operation: Operation
    test: int
    ifTrue: int
    ifFalse: int
    inspectCount: uint64

proc parseInput(input: string): seq[Monkey] =
  let lines = input.splitLines().mapIt(it.strip.split(": "))
  var n: int
  var monkeys: seq[Monkey]
  while true:
    if n >= lines.len: break
    var m: Monkey
    assert lines[n][0].startsWith("Monkey")
    assert lines[n+1][0] == "Starting items"
    m.items = lines[n+1][1].split(", ").mapIt(uint64(it.parseInt))
    assert lines[n+2][0] == "Operation"
    let opBits = lines[n+2][1].split("new = old ")[1].split({' '})
    let operator = case opBits[0]
    of "+": Add
    of "*": Mul
    else: raise newException(Exception, "unknown operator")
    if opBits[1] == "old":
      m.operation = Operation(operator: operator, operand: Old)
    else:
      m.operation = Operation(operator: operator, operand: Num, value: opBits[1].parseInt)
    assert lines[n+3][0] == "Test"
    m.test = lines[n+3][1].split("divisible by ")[1].parseInt
    assert lines[n+4][0] == "If true"
    m.ifTrue = lines[n+4][1].split("throw to monkey ")[1].parseInt
    assert lines[n+5][0] == "If false"
    m.ifFalse = lines[n+5][1].split("throw to monkey ")[1].parseInt
    monkeys.add m
    n += 7
  result = monkeys

proc part1(input: string) =
  var monkeys = parseInput(input)
  var round: int
  while true:
    for monkey in monkeys.mitems:
      while monkey.items.len > 0:
        let item = monkey.items[0]
        monkey.items.delete(0)
        monkey.inspectCount += 1
        var operand = case monkey.operation.operand
        of Old: item
        of Num: uint64(monkey.operation.value)
        var worry = case monkey.operation.operator
        of Add: item + operand
        of Mul: item * operand
        worry = worry div 3
        let next = if worry mod uint64(monkey.test) == 0:
          monkey.ifTrue
        else:
          monkey.ifFalse
        monkeys[next].items.add(worry)
    round += 1
    #echo "After round ", round, ", the monkeys are holding:"
    #for i, m in monkeys:
      #echo "monkey ", i, ": ", m.items
    if round == 20:
      break
  monkeys.sort do (x, y: Monkey) -> int:
      cmp(x.inspectCount, y.inspectCount)
  echo monkeys[^1].inspectCount * monkeys[^2].inspectCount

proc part2(input: string) =
  var monkeys = parseInput(input)
  let LCM = lcm(monkeys.mapIt(it.test))
  var round: int
  while true:
    for monkey in monkeys.mitems:
      while monkey.items.len > 0:
        let item = monkey.items[0]
        monkey.items.delete(0)
        monkey.inspectCount += 1
        var operand = case monkey.operation.operand
        of Old: item
        of Num: uint64(monkey.operation.value)
        var worry = case monkey.operation.operator
        of Add: item + operand
        of Mul: item * operand
        let next = if worry mod uint64(monkey.test) == 0:
          monkey.ifTrue
        else:
          monkey.ifFalse
        monkeys[next].items.add(worry mod uint64(LCM))
    round += 1
    #if round == 1 or round == 20 or round == 40 or round mod 1000 == 0:
      #echo "=== After round ", round, " ==="
      #for i, m in monkeys:
        #echo "Monkey ", i, " inspected items ", m.inspectCount, " times."
    if round == 10000:
      break
  monkeys.sort do (x, y: Monkey) -> int:
      cmp(x.inspectCount, y.inspectCount)
  echo monkeys[^1].inspectCount * monkeys[^2].inspectCount

let input = readAll(stdin)
part1(input)
part2(input)
