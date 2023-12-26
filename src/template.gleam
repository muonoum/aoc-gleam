import gleam/bool as _
import gleam/dict as _
import gleam/int as _
import gleam/io
import gleam/iterator as _
import gleam/list as _
import gleam/pair as _
import gleam/result as _
import gleam/set as _
import gleam/string as _
import lib as _
import lib/read as _

pub fn part1(input: String) -> Int {
  parse(input)
  |> io.debug
  -1
}

pub fn part2(_input: String) -> Int {
  -1
}

pub fn parse(input: String) {
  input
}
