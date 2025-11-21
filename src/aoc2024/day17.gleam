import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import lib/read

pub type Registers {
  Registers(ax: Int, bx: Int, cx: Int)
}

fn put_ax(registers, ax) {
  Registers(..registers, ax:)
}

fn put_bx(registers, bx) {
  Registers(..registers, bx:)
}

fn put_cx(registers, cx) {
  Registers(..registers, cx:)
}

pub fn part1(input: String) -> Int {
  let #(registers, program) = parse(input)

  run(registers, program, 0, [])
  |> list.map(int.to_string)
  |> string.join(",")
  |> io.println

  -1
}

pub fn part2(_input: String) -> Int {
  -1
}

fn run(
  registers: Registers,
  program: Dict(Int, Int),
  counter: Int,
  output: List(Int),
) -> List(Int) {
  let Registers(ax:, bx:, cx:) = registers
  let opcode = dict.get(program, counter)
  let operand = dict.get(program, counter + 1)

  case opcode, operand {
    Error(Nil), _operand -> list.reverse(output)

    Ok(0), Ok(operand) -> {
      let result = ax / lib.power(2, get_combo(registers, operand))
      put_ax(registers, result) |> run(program, counter + 2, output)
    }

    Ok(6), Ok(operand) -> {
      let result = ax / lib.power(2, get_combo(registers, operand))
      put_bx(registers, result) |> run(program, counter + 2, output)
    }

    Ok(7), Ok(operand) -> {
      let result = ax / lib.power(2, get_combo(registers, operand))
      put_cx(registers, result) |> run(program, counter + 2, output)
    }

    Ok(1), Ok(operand) -> {
      let result = int.bitwise_exclusive_or(bx, operand)
      put_bx(registers, result) |> run(program, counter + 2, output)
    }

    Ok(2), Ok(operand) -> {
      let operand = get_combo(registers, operand)
      put_bx(registers, operand % 8) |> run(program, counter + 2, output)
    }

    Ok(3), Ok(operand) -> {
      case ax {
        0 -> run(registers, program, counter + 2, output)
        _ -> run(registers, program, operand, output)
      }
    }

    Ok(4), Ok(_operand) -> {
      let result = int.bitwise_exclusive_or(bx, cx)
      put_bx(registers, result) |> run(program, counter + 2, output)
    }

    Ok(5), Ok(operand) -> {
      let operand = get_combo(registers, operand)
      run(registers, program, counter + 2, [operand % 8, ..output])
    }

    _opcode, Error(Nil) -> panic as "missing operand"
    Ok(_opcode), _operand -> panic as "unknown opcode"
  }
}

fn get_combo(registers: Registers, operand: Int) -> Int {
  case operand {
    0 | 1 | 2 | 3 -> operand
    4 -> registers.ax
    5 -> registers.bx
    6 -> registers.cx
    n -> panic as string.inspect(n)
  }
}

pub fn parse(input: String) {
  let registers = Registers(ax: 0, bx: 0, cx: 0)
  use #(registers, program) as state, line <- list.fold(read.lines(input), {
    #(registers, dict.new())
  })

  let put = fn(into, value) {
    let assert Ok(value) = int.parse(value)
    into(registers, value)
  }

  case line {
    "" -> state
    "Register A: " <> value -> #(put(put_ax, value), program)
    "Register B: " <> value -> #(put(put_bx, value), program)
    "Register C: " <> value -> #(put(put_cx, value), program)
    "Program: " <> program -> #(registers, parse_program(program))
    _else -> panic
  }
}

fn parse_program(program: String) {
  dict.from_list({
    use step, index <- list.index_map(read.integers(program, ","))
    #(index, step)
  })
}
