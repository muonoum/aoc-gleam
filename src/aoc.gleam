import day1_submitted
import day1_cleanup
import gleam/io
import simplifile

fn day1_submitted() {
  let assert Ok(input1) = simplifile.read("src/day1.txt")
  io.println("# day1 (submitted)")
  io.debug(#("part1", day1_submitted.part1(input1)))
  io.debug(#("part2", day1_submitted.part2(input1)))
}

fn day1_cleanup() {
  let assert Ok(input1) = simplifile.read("src/day1.txt")
  io.println("# day1 (cleanup)")
  io.debug(#("part1", day1_cleanup.part1(input1)))
  io.debug(#("part2", day1_cleanup.part2(input1)))
}

pub fn main() {
  day1_submitted()
  day1_cleanup()
}
