import day1
import gleam/io
import simplifile
import gleam/erlang

pub fn main() {
  let assert Ok(priv) = erlang.priv_directory("aoc")
  let assert Ok(input1) = simplifile.read(priv <> "/day1.txt")

  day1.part1(input1)
  |> io.debug

  day1.part2(input1)
  |> io.debug
}
