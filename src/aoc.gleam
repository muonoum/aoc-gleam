import day1_submitted
import day1_cleanup
import gleam/io
import simplifile
import gleam/erlang

fn day1_submitted() {
  io.println("# day1 (submitted)")
  let assert Ok(priv) = erlang.priv_directory("aoc")
  let assert Ok(input1) = simplifile.read(priv <> "/day1.txt")
  io.debug(#("part1", day1_submitted.part1(input1)))
  io.debug(#("part2", day1_submitted.part2(input1)))
}

fn day1_cleanup() {
  io.println("# day1 (cleanup)")
  let assert Ok(priv) = erlang.priv_directory("aoc")
  let assert Ok(input1) = simplifile.read(priv <> "/day1.txt")
  io.debug(#("part1", day1_cleanup.part1(input1)))
  io.debug(#("part2", day1_cleanup.part2(input1)))
}

pub fn main() {
  day1_submitted()
  day1_cleanup()
}
