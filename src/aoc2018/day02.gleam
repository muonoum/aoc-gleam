import gleam/dict
import gleam/function
import gleam/list
import gleam/string
import lib/read

pub fn part1(input: String) -> Int {
  let boxes = {
    use letters <- list.map(parse(input))
    list.group(letters, function.identity)
    |> dict.values()
    |> list.map(list.length)
    |> list.filter(fn(v) { v > 1 })
    |> list.unique
  }

  let #(twos, threes) = {
    use #(twos, threes), groups <- list.fold(boxes, #(0, 0))
    case groups {
      [2] -> #(twos + 1, threes)
      [3] -> #(twos, threes + 1)
      _else -> #(twos + 1, threes + 1)
    }
  }

  twos * threes
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) -> List(List(String)) {
  read.lines(input)
  |> list.map(string.to_graphemes)
}
