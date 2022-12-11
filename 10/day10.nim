import std/strutils
import std/sugar

type
  Instruction = enum
    noop
    addx
  Operation = tuple[instruction: Instruction, operand: int]
  CPU = object
    x: int
    cycleCount: int
    signalStrength: int

proc parseInput(input: string): seq[Operation] =
  result = collect:
    for line in input.splitLines():
      if line == "": break
      let bits = line.split({' '})
      let inst = parseEnum[Instruction](bits[0])
      if inst == addx:
        (instruction: inst, operand: parseInt(bits[1]))
      else:
        (instruction: inst, operand: 0)

proc advanceClock(cpu: var CPU, numCycles: int) =
  for i in 0..<numCycles:
    if cpu.cycleCount == 20 or (cpu.cycleCount - 20) mod 40 == 0:
      cpu.signalStrength += cpu.cycleCount * cpu.x
    cpu.cycleCount += 1

proc part1(operations: seq[Operation]) =
  var cpu = CPU(x: 1, cycleCount: 1)
  for op in operations:
    case op.instruction
    of noop:
      cpu.advanceClock(1)
    of addx:
      cpu.advanceClock(2)
      cpu.x += op.operand
  echo cpu.signalStrength

const Cols = 40
type Screen = array[6, array[Cols, bool]]

proc print(screen: Screen) =
  for row in screen:
    for col in row:
      stdout.write if col: '#' else: '.'
    echo ""

proc rasterize(screen: var Screen, cpu: var CPU, numCycles: int) =
  for i in 0..<numCycles:
    let y = (cpu.cycleCount-1) div Cols
    let x = (cpu.cycleCount-1) mod Cols
    screen[y][x] = cpu.x - 1 <= x and x <= cpu.x + 1
    cpu.cycleCount += 1

proc part2(operations: seq[Operation]) =
  var cpu = CPU(x: 1, cycleCount: 1)
  var screen: Screen
  for op in operations:
    case op.instruction
    of noop:
      screen.rasterize(cpu, 1)
    of addx:
      screen.rasterize(cpu, 2)
      cpu.x += op.operand
  screen.print

let operations = parseInput(readAll(stdin))
part1(operations)
part2(operations)
