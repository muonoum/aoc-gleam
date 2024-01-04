import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import lib/read

pub fn part1(input: String) -> Int {
  let program =
    parse(input)
    |> dict.insert(1, 12)
    |> dict.insert(2, 2)

  let assert Ok(result) =
    run(program, 0)
    |> dict.get(0)

  result
}

pub fn part2(input: String) -> Int {
  let program = parse(input)
  let range = list.range(0, 99)
  let target = 19_690_720

  let execute = fn(one, two) {
    program
    |> dict.insert(1, one)
    |> dict.insert(2, two)
    |> run(0)
    |> dict.get(0)
  }

  let find = fn(over, from, fun) {
    use last, try <- list.fold_until(over, from)
    let assert Ok(result) = fun(try)
    use <- bool.guard(result < target, list.Continue(try))
    use <- bool.guard(result == target, list.Stop(try))
    list.Stop(last)
  }

  let verb = find(range, 0, execute(_, 0))
  let noun = find(range, verb, execute(verb, _))
  100 * verb + noun
}

fn run(program: Dict(Int, Int), pointer: Int) {
  let assert Ok(opcode) = dict.get(program, pointer)
  use <- bool.lazy_guard(opcode == 99, fn() { program })
  use <- bool.lazy_guard(opcode == 1, fn() { map(program, pointer, int.add) })
  use <- bool.lazy_guard(opcode == 2, fn() {
    map(program, pointer, int.multiply)
  })
  panic as string.inspect(opcode)
}

fn map(program, pointer, fun) {
  let assert Ok(a) =
    dict.get(program, pointer + 1)
    |> result.try(dict.get(program, _))
  let assert Ok(b) =
    dict.get(program, pointer + 2)
    |> result.try(dict.get(program, _))

  let assert Ok(output) = dict.get(program, pointer + 3)
  dict.insert(program, output, fun(a, b))
  |> run(pointer + 4)
}

pub fn parse(input: String) {
  dict.from_list({
    use grapheme, index <- list.index_map(
      read.fields(input, ",")
      |> list.filter_map(int.parse),
    )
    #(index, grapheme)
  })
}
