import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/iterator.{type Iterator}
import gleam/list
import gleam/option
import gleam/result
import gleam/set
import lib/int/vector.{type V2, V2}
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
  let cycles = set.from_list([20, 60, 100, 140, 180, 220])
  use signal, machine <- iterator.fold_until(machine, 0)
  use <- bool.guard(machine.program == [], list.Stop(signal))
  use <- bool.guard(!set.contains(cycles, machine.cycle), list.Continue(signal))
  let assert Ok(x) = dict.get(machine.registers, X)
  list.Continue(signal + machine.cycle * x)
}

pub fn part2(input: String) -> Int {
  render({
    let machine = load(input)
    use display, machine <- iterator.fold_until(machine, dict.new())
    use <- bool.guard(machine.program == [], list.Stop(display))
    let assert Ok(sprite) = dict.get(machine.registers, X)
    let sprite = set.from_list([sprite - 1, sprite, sprite + 1])
    let position = V2(machine.cycle % 40 - 1, { machine.cycle - 1 } / 40)
    use <- bool.guard(!set.contains(sprite, position.x), list.Continue(display))
    list.Continue(dict.insert(display, position, "#"))
  })

  -1
}

fn render(display: Dict(V2, String)) {
  use y <- list.map(list.range(0, 5))
  render_row(y, display)
  io.println("")
}

fn render_row(y: Int, display: Dict(V2, String)) {
  use x <- list.map(list.range(0, 39))
  dict.get(display, V2(x, y))
  |> result.unwrap(".")
  |> io.print
}

fn load(source: String) -> Iterator(Machine) {
  let program = parse(source)
  let registers = dict.from_list([#(X, 1)])
  let machine = Machine(1, program, registers)

  use machine <- iterator.iterate(machine)
  let machine = Machine(..machine, cycle: machine.cycle + 1)
  case machine.program {
    [] -> machine

    [#(instruction, 1), ..program] -> {
      let machine = execute(instruction, machine)
      Machine(..machine, program: program)
    }

    [#(instruction, cycles), ..program] -> {
      let program = [#(instruction, cycles - 1), ..program]
      Machine(..machine, program: program)
    }
  }
}

fn execute(instruction: Instruction, machine: Machine) -> Machine {
  case instruction {
    Noop -> machine

    Add(register, number) -> {
      Machine(
        ..machine,
        registers: {
          use content <- dict.update(machine.registers, register)
          option.map(content, int.add(_, number))
          |> option.unwrap(number)
        },
      )
    }
  }
}

pub fn parse(input: String) {
  use line <- list.map(read.lines(input))
  parse_instruction(line)
}

fn parse_instruction(line: String) -> #(Instruction, Int) {
  case line {
    "addx " <> number -> {
      let assert Ok(number) = int.parse(number)
      #(Add(X, number), 2)
    }
    "noop" -> #(Noop, 1)
    _else -> panic
  }
}
