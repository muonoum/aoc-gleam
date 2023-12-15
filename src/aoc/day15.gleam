import gleam/int
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  string.trim(input)
  |> string.split(",")
  |> list.map(hash)
  |> int.sum
}

pub fn part2(_input: String) -> Int {
  -1
}

fn hash(string: String) -> Int {
  use current, grapheme <- list.fold(string.to_graphemes(string), 0)
  let assert [codepoint] = string.to_utf_codepoints(grapheme)
  let code = string.utf_codepoint_to_int(codepoint)
  let assert Ok(current) = int.remainder({ current + code } * 17, 256)
  current
}
