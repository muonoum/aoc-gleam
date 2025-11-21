import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
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

  let dv = fn(operand, put) {
    let result = ax / lib.power(2, get_combo(registers, operand))
    run(put(registers, result), program, counter + 2, output)
  }

  let xor = fn(operand, put) {
    let result = int.bitwise_exclusive_or(bx, operand)
    run(put(registers, result), program, counter + 2, output)
  }

  case opcode, operand {
    Error(Nil), _operand -> list.reverse(output)
    Ok(0), Ok(operand) -> dv(operand, put_ax)
    Ok(1), Ok(operand) -> xor(operand, put_bx)

    Ok(2), Ok(operand) -> {
      let operand = get_combo(registers, operand)
      run(put_bx(registers, operand % 8), program, counter + 2, output)
    }

    Ok(3), Ok(operand) -> {
      case ax {
        0 -> run(registers, program, counter + 2, output)
        _ -> run(registers, program, operand, output)
      }
    }

    Ok(4), Ok(_operand) -> xor(cx, put_bx)

    Ok(5), Ok(operand) -> {
      let operand = get_combo(registers, operand)
      run(registers, program, counter + 2, [operand % 8, ..output])
    }

    Ok(6), Ok(operand) -> dv(operand, put_bx)
    Ok(7), Ok(operand) -> dv(operand, put_cx)
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

pub fn parse(input: String) -> #(Registers, Dict(Int, Int)) {
  parse_loop(read.lines(input), Registers(ax: 0, bx: 0, cx: 0), dict.new())
}

fn parse_loop(
  lines: List(String),
  registers: Registers,
  program: Dict(Int, Int),
) -> #(Registers, Dict(Int, Int)) {
  use <- bool.guard(lines == [], #(registers, program))
  let assert [line, ..lines] = lines

  let parse_register = fn(into, value) {
    let assert Ok(value) = int.parse(value)
    parse_loop(lines, into(registers, value), program)
  }

  let parse_program = fn(program) {
    let program = list.index_map(read.integers(program, ","), pair.new)
    parse_loop(lines, registers, dict.from_list(list.map(program, pair.swap)))
  }

  case line {
    "" -> parse_loop(lines, registers, program)
    "Register A: " <> value -> parse_register(put_ax, value)
    "Register B: " <> value -> parse_register(put_bx, value)
    "Register C: " <> value -> parse_register(put_cx, value)
    "Program: " <> program -> parse_program(program)
    _else -> panic
  }
}
