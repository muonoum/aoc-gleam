import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  use floor, grapheme <- list.fold(string.to_graphemes(input), 0)

  case grapheme {
    "(" -> floor + 1
    ")" -> floor - 1
    _ -> panic
  }
}

pub fn part2(input: String) -> Int {
  let instructions = {
    use grapheme, index <- list.index_map(string.to_graphemes(input))
    #(index + 1, grapheme)
  }

  use floor, #(position, grapheme) <- list.fold_until(instructions, 0)

  let next = case grapheme {
    "(" -> floor + 1
    ")" -> floor - 1
    _ -> panic
  }

  case next {
    -1 -> list.Stop(position)
    _ -> list.Continue(next)
  }
}
