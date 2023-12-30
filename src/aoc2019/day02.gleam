import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
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

pub fn part2(_input: String) -> Int {
  -1
}

fn run(program: Dict(Int, Int), pointer: Int) {
  case dict.get(program, pointer) {
    Ok(1) -> {
      let #(a, b, output) = lookup(program, pointer)
      dict.insert(program, output, a + b)
      |> run(pointer + 4)
    }

    Ok(2) -> {
      let #(a, b, output) = lookup(program, pointer)
      dict.insert(program, output, a * b)
      |> run(pointer + 4)
    }

    Ok(99) -> program

    _else -> panic
  }
}

fn lookup(program, pointer) {
  let assert Ok(a) =
    dict.get(program, pointer + 1)
    |> result.try(dict.get(program, _))

  let assert Ok(b) =
    dict.get(program, pointer + 2)
    |> result.try(dict.get(program, _))

  let assert Ok(output) = dict.get(program, pointer + 3)
  #(a, b, output)
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
