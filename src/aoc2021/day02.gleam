import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import lib
import lib/int/v2.{V2}
import lib/read

pub type Movement {
  Down
  Forward
  Up
}

pub fn part1(input: String) -> Int {
  let V2(x, y) = {
    use V2(x, y), #(direction, count) <- list.fold(parse(input), V2(0, 0))

    case direction {
      Down -> V2(x, y + count)
      Forward -> V2(x + count, y)
      Up -> V2(x, y - count)
    }
  }

  x * y
}

pub fn part2(input: String) -> Int {
  let V2(x, y) = {
    use <- lib.return(pair.first)
    let state = #(V2(0, 0), 0)
    use #(V2(x, y), aim), #(direction, count) <- list.fold(parse(input), state)

    case direction {
      Down -> #(V2(x, y), aim + count)
      Forward -> #(V2(x + count, y + count * aim), aim)
      Up -> #(V2(x, y), aim - count)
    }
  }

  x * y
}

pub fn parse(input: String) {
  use line <- list.filter_map(read.lines(input))
  parse_movement(line)
}

fn parse_movement(line) {
  case line {
    "forward " <> count ->
      int.parse(count)
      |> result.map(pair.new(Forward, _))

    "up " <> count ->
      int.parse(count)
      |> result.map(pair.new(Up, _))

    "down " <> count ->
      int.parse(count)
      |> result.map(pair.new(Down, _))

    _else -> panic
  }
}
