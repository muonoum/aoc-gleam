import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/set.{type Set}
import gleam/yielder.{type Yielder}
import lib
import lib/int/v2.{type V2, V2}
import lib/read

pub type Machine {
  Machine(
    cycle: Int,
    program: List(#(Instruction, Int)),
    registers: Dict(Register, Int),
  )
}

pub type Register {
  X
}

pub type Instruction {
  Noop
  Add(Register, Int)
}

pub fn part1(input: String) -> Int {
  let machine = load(input)
  use signal, machine <- yielder.fold_until(start(machine), 0)
  use <- bool.guard(done(machine), list.Stop(signal))
  use <- lib.return(list.Continue)
  use <- bool.guard(machine.cycle % 40 != 20, signal)
  let assert Ok(x) = dict.get(machine.registers, X)
  signal + machine.cycle * x
}

pub fn part2(input: String) -> Int {
  render({
    let machine = load(input)
    use display, machine <- yielder.fold_until(start(machine), set.new())
    use <- bool.guard(done(machine), list.Stop(display))
    use <- lib.return(list.Continue)
    let assert Ok(sprite) = dict.get(machine.registers, X)
    let pixel = V2(machine.cycle % 40 - 1, { machine.cycle - 1 } / 40)
    use <- bool.guard(pixel.x < sprite - 1 || pixel.x > sprite + 1, display)
    set.insert(display, pixel)
  })

  -1
}

fn load(source: String) -> Machine {
  let program = parse(source)
  let registers = dict.from_list([#(X, 1)])
  Machine(1, program, registers)
}

fn done(machine: Machine) -> Bool {
  machine.program == []
}

fn start(machine: Machine) -> Yielder(Machine) {
  use machine <- yielder.iterate(machine)

  case machine.program {
    [] -> machine

    [#(instruction, 1), ..program] -> {
      let registers = update(machine.registers, instruction)
      Machine(machine.cycle + 1, program, registers)
    }

    [#(instruction, cycles), ..program] -> {
      let program = [#(instruction, cycles - 1), ..program]
      Machine(machine.cycle + 1, program, machine.registers)
    }
  }
}

fn update(
  registers: Dict(Register, Int),
  instruction: Instruction,
) -> Dict(Register, Int) {
  case instruction {
    Noop -> registers

    Add(register, number) -> {
      use content <- dict.upsert(registers, register)
      option.map(content, int.add(_, number))
      |> option.unwrap(number)
    }
  }
}

fn render(display: Set(V2)) {
  use y <- list.map(list.range(0, 5))
  render_row(y, display)
  io.println("")
}

fn render_row(y: Int, display: Set(V2)) {
  use x <- list.map(list.range(0, 39))

  case set.contains(display, V2(x, y)) {
    True -> io.print("\u{2593}")
    False -> io.print(" ")
  }
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))

  case line {
    "noop" -> #(Noop, 1)

    "addx " <> number -> {
      let assert Ok(number) = int.parse(number)
      #(Add(X, number), 2)
    }

    _else -> panic
  }
}
