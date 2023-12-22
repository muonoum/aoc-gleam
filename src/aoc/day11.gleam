import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import lib

pub fn part1(input: String) -> Int {
  let universe = {
    use point <- list.filter_map(
      parse(input)
      |> list.map(string.split(_, ""))
      |> list.reverse()
      |> list.fold([], expand)
      |> list.transpose()
      |> list.reverse()
      |> list.fold([], expand)
      |> list.transpose()
      |> lib.grid,
    )

    case point {
      #(position, "#") -> Ok(position)
      _else -> Error(Nil)
    }
  }

  int.sum({
    use #(a, b) <- list.map(list.combination_pairs(universe))
    let dx = int.absolute_value({ a.x - b.x })
    let dy = int.absolute_value({ a.y - b.y })
    dx + dy
  })
}

pub fn part2(input: String) -> Int {
  parse(input)
  -1
}

fn expand(universe, row) {
  case list.all(row, fn(v) { v == "." }) {
    True -> [row, row, ..universe]
    False -> [row, ..universe]
  }
}

pub fn parse(input) {
  let lines = string.split(input, "\n")
  use line <- list.filter_map(lines)
  use <- bool.guard(line == "", Error(Nil))

  Ok(line)
}
