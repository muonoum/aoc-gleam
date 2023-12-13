import gleam/bool
import gleam/int as _
import gleam/io
import gleam/iterator as _
import gleam/list
import gleam/string

pub fn part1(input: String) -> Int {
  parse(input)
  |> io.debug
  -1
}

pub fn part2(input: String) -> Int {
  parse(input)
  |> io.debug
  -1
}

pub fn parse(input) {
  let lines = string.split(input, "\n")
  use line <- list.filter_map(lines)
  use <- bool.guard(line == "", Error(Nil))

  Ok(line)
}
